#!/usr/bin/make -f
# Change the default shell /bin/sh which does not implement 'source'
# source is needed to work in a python virtualenv
SHELL := /bin/bash
LAST_TAG := $(shell git describe --tags --abbrev=0)
LIBVIRT_STORAGE_PATH := /var/lib/libvirt/images/

# remove 'download_extra' to build without third party software/dotfiles
all: install_buildenv download_extra build

.PHONY: download_extra # download third-party components
download_extra:
	make -f Makefile.extra

.PHONY: install_buildenv # install packages required to build the image
install_buildenv:
	sudo apt -y install live-build make build-essential wget git unzip colordiff apt-transport-https rename ovmf rsync python3-venv gnupg

##############################

.PHONY: clean # clear all caches, only required when changing the mirrors/architecture config
clean:
	sudo lb clean --all
	make -f Makefile.extra clean
	rm -rf .venv

build:
	# Build the live system/ISO image
	sudo lb clean --all
	sudo lb config
	sudo lb build

##############################

.PHONY: bump_version # bump all version indicators before a new release
bump_version:
	@echo "Please set version to $(LAST_TAG) in doc/md/conf.py config/bootloaders/grub-pc/live-theme/theme.txt config/bootloaders/isolinux/live.cfg.in config/bootloaders/isolinux/menu.cfg auto/config doc/md/download-and-installation.md doc/md/index.md"

.PHONY: release # generate release files
release: checksums sign_checksums release_archive

.PHONY: checksums # generate checksums of the resulting ISO image
checksums:
	@mkdir -p iso/
	mv *.iso iso/
	cd iso/; \
	rename "s/live-image/debian-live-config-$(LAST_TAG)-debian-bookworm/" *; \
	rename "s/.hybrid.iso/.iso/" *; \
	sha512sum *.iso  > SHA512SUMS; \

# the signing key must be present and loaded on the build machine
# gpg --export-secret-keys --armor $MAINTAINER_EMAIL > $MAINTAINER_EMAIL.key
# rsync -avzP $MAINTAINER_EMAIL.key $BUILD_HOST:
# ssh -t $BUILD_HOST gpg --import $MAINTAINER_EMAIL.key
.PHONY: sign_checksums # sign checksums with a GPG private key
sign_checksums:
	cd iso; \
	gpg --detach-sign --armor SHA512SUMS; \
	mv SHA512SUMS.asc SHA512SUMS.sign
	# Export the public GPG key used for signing
	gpg --export --armor nodiscc@gmail.com > iso/debian-live-config-release.key

.PHONY: release_archive # generate a source code archive
release_archive:
	git archive --format=zip -9 HEAD -o $$(basename $$PWD)-$$(git rev-parse HEAD).zip

################################

.PHONY: tests # run all tests
tests: test_imagesize test_kvm_bios test_kvm_uefi

.PHONY: test_imagesize # ensure the image size is less than 2GB
test_imagesize:
	@size=$$(du -b iso/*.iso | cut -f 1); \
	echo "[INFO] ISO image size: $$size bytes"; \
	if [[ "$$size" -gt 2147483648 ]]; then \
		echo '[WARNING] ISO image size is larger than 2GB!'; exit 1; \
	fi

.PHONY: debug_imagesize # generate ISO/squashfs image disk usage report (requires duc)
debug_imagesize:
	sudo mkdir -p /mnt/debian-live-config-iso /mnt/debian-live-config-squashfs
	-sudo mount iso/*.iso /mnt/debian-live-config-iso
	-sudo mount /mnt/debian-live-config-iso/live/filesystem.squashfs /mnt/debian-live-config-squashfs
	sudo duc index /mnt/debian-live-config-squashfs -d debian-live-config-squashfs.duc-index
	sudo duc index /mnt/debian-live-config-iso -d debian-live-config-iso.duc-index
	#duc gui /mnt/debian-live-config-squashfs -d debian-live-config-squashfs.duc-index
	duc gui /mnt/debian-live-config-iso -d debian-live-config-iso.duc-index

# requirements: iso image must be downloaded from the build machine beforehand
# rsync -avzP $BUILD_HOST:/var/debian-live-config/iso ./
# cp iso/*.iso /var/lib/libvirt/images/
.PHONY: test_kvm_bios # test resulting live image in libvirt VM with legacy BIOS
test_kvm_bios:
	virt-install --name dlc-test --osinfo debian11 --boot cdrom --video virtio --disk path=$(LIBVIRT_STORAGE_PATH)/dlc-test-disk0.qcow2,format=qcow2,size=20,device=disk,bus=virtio,cache=none --cdrom "$(LIBVIRT_STORAGE_PATH)debian-live-config-$(LAST_TAG)-debian-bookworm-amd64.iso" --memory 3048 --vcpu 2
	virsh destroy dlc-test
	virsh undefine dlc-test
	rm -f $$PWD/dlc-test-disk0.qcow2

# UEFI support must be enabled in QEMU config for EFI install tests https://wiki.archlinux.org/index.php/Libvirt#UEFI_Support (/usr/share/OVMF/*.fd)
.PHONY: test_kvm_uefi # test resulting live image in libvirt VM with UEFI
test_kvm_uefi:
	virt-install --name dlc-test --osinfo debian11 --boot loader=/usr/share/OVMF/OVMF_CODE.fd --video virtio --disk path=$(LIBVIRT_STORAGE_PATH)/dlc-test-disk0.qcow2,format=qcow2,size=20,device=disk,bus=virtio,cache=none --cdrom "$(LIBVIRT_STORAGE_PATH)debian-live-config-$(LAST_TAG)-debian-bookworm-amd64.iso" --memory 3048 --vcpu 2
	virsh destroy dlc-test
	virsh undefine dlc-test
	rm -f $$PWD/dlc-test-disk0.qcow2

##### DOCUMENTATION #####
# requirements: sudo apt install git jq
#               gitea-cli config defined in ~/.config/gitearc:
# export GITEA_API_TOKEN="AAAbbbCCCdddZZ"
# gitea.issues() {
# 	split_repo "$1"
# 	auth curl --silent --insecure "https://gitea.example.org/api/v1/repos/$REPLY/issues?limit=1000"
# }
.PHONY: update_todo # manual - Update TODO.md by fetching issues from the main gitea instance API
update_todo:
	git clone https://github.com/bashup/gitea-cli gitea-cli
	echo '<!-- This file is automatically generated by "make update_todo" -->' >| doc/md/TODO.md
	echo -e "\n### nodiscc/debian-live-config\n" >> doc/md/TODO.md; \
	./gitea-cli/bin/gitea issues nodiscc/debian-live-config | jq -r '.[] | "- #\(.number) - \(.title) - **`\(.milestone.title // "-")`** `\(.labels | map(.name) | join(","))`"'  | sed 's/ - `null`//' >> doc/md/TODO.md
	rm -rf gitea-cli

.PHONY: doc # run all documentation generation tasks
doc: doc_package_lists doc_md doc_html

.PHONY: doc_md # generate markdown documentation
doc_md: update_todo
	cp README.md doc/md/index.md
	cp CHANGELOG.md doc/md/
	cp LICENSE doc/md/LICENSE.md
	sed -i 's|doc/md/||g' doc/md/*.md

.PHONY: doc_package_lists # generate markdown package list from config/package-lists/
doc_package_lists:
	./doc/gen_package_lists.py

.PHONY: install_dev_docs # install documentation generator (sphinx + markdown + theme)
install_dev_docs:
	python3 -m venv .venv/
	source .venv/bin/activate && pip3 install sphinx myst_parser sphinx_rtd_theme sphinx_external_toc

SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = doc/md    # répertoire source (markdown)
BUILDDIR      = doc/html  # répertoire destination (html)
.PHONY: doc_html # manual - HTML documentation generation (sphinx-build --help)
doc_html: install_dev_docs
	source .venv/bin/activate && sphinx-build -c doc/md -b html doc/md doc/html

.PHONY: codespell # manual - run interactive spell checker
codespell:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
    pip3 install codespell && \
	codespell --write-changes --interactive 3 --uri-ignore-words-list '*' \
	--skip '*.venv/*,./.git/*,./doc/md/packages/*'

#####

.PHONY: help # generate list of targets with descriptions
help:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1	\2/' | expand -t20

#####

.PHONY: docker_compose
docker_compose:
	docker compose up --build --force-recreate
	docker compose down
