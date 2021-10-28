#!/usr/bin/make -f
# Change the default shell /bin/sh which does not implement 'source'
# source is needed to work in a python virtualenv
SHELL := /bin/bash
LAST_TAG := $(shell git describe --tags --abbrev=0)

# remove 'download_extra' to build without third party software/dotfiles
all: install_buildenv download_extra build

download_extra:
	make -f Makefile.extra

install_buildenv:
	# Install packages required to build the image
	sudo apt -y install live-build make build-essential wget git unzip colordiff apt-transport-https rename ovmf rsync python3-venv gnupg

##############################

# clear all caches, only required when changing the mirrors/architecture config
clean:
	sudo lb clean --all
	make -f Makefile.extra clean

bump_version:
	@echo "Please set version to $(LAST_TAG) in Makefile doc/md/conf.py config/bootloaders/grub-pc/live-theme/theme.txt config/bootloaders/isolinux/live.cfg.in config/bootloaders/isolinux/menu.cfg auto/config doc/md/download-and-installation.md doc/md/index.md"

build:
	# Build the live system/ISO image
	sudo lb clean --all
	sudo lb config
	sudo lb build

##############################

release: checksums sign_checksums release_archive

checksums:
	# Generate checksums of the resulting ISO image
	@mkdir -p iso/
	mv *.iso iso/
	cd iso/; \
	rename "s/live-image/dlc-$(LAST_TAG)-debian-bullseye/" *; \
	sha512sum *.iso  > SHA512SUMS; \

# the signing key must be present and loaded on the build machine
# gpg --export-secret-keys --armor $MAINTAINER_EMAIL > $MAINTAINER_EMAIL.key
# rsync -avzP $MAINTAINER_EMAIL.key $BUILD_HOST:
# ssh -t $BUILD_HOST gpg --import $MAINTAINER_EMAIL.key
sign_checksums:
	# Sign checksums with a GPG private key
	cd iso; \
	gpg --detach-sign --armor SHA512SUMS; \
	mv SHA512SUMS.asc SHA512SUMS.sign
	# Export the public GPG key used for signing
	gpg --export --armor nodiscc@gmail.com > dlc-release.key

release_archive:
	git archive --format=zip -9 HEAD -o $$(basename $$PWD)-$$(git rev-parse HEAD).zip

################################

tests: test_imagesize test_kvm_bios test_kvm_uefi

test_imagesize:
	@size=$$(du -b iso/*.iso | cut -f 1); \
	echo "[INFO] ISO image size: $$size bytes"; \
	if [[ "$$size" -gt 2147483648 ]]; then \
		echo '[WARNING] ISO image size is larger than 2GB!'; \
	fi

# iso image must be downloaded from the build machine beforehand
# rsync -avzP $BUILD_HOST:/var/debian-live-config/debian-live-config/iso/ ./
test_kvm_bios:
	# Run the resulting image in KVM/virt-manager (legacy BIOS mode)
	virt-install --name dlc-test --boot cdrom --video virtio --disk path=$$PWD/dlc-test-disk0.qcow2,format=qcow2,size=20,device=disk,bus=virtio,cache=none --cdrom 'iso/dlc-$(LAST_TAG)-debian-bullseye-amd64.hybrid.iso' --memory 4096 --vcpu 2
	virsh destroy dlc-test
	virsh undefine dlc-test
	rm -f $$PWD/dlc-test-disk0.qcow2

test_kvm_uefi:
	# Run the resulting image in KVM/virt-manager (UEFI mode)
	# UEFI support must be enabled in QEMU config for EFI install tests https://wiki.archlinux.org/index.php/Libvirt#UEFI_Support (/usr/share/OVMF/*.fd)
	virt-install --name dlc-test --boot loader=/usr/share/OVMF/OVMF_CODE.fd --video virtio --disk path=$$PWD/dlc-test-disk0.qcow2,format=qcow2,size=20,device=disk,bus=virtio,cache=none --cdrom 'iso/dlc-$(LAST_TAG)-debian-bullseye-amd64.hybrid.iso' --memory 4096 --vcpu 2
	virsh destroy dlc-test
	virsh undefine dlc-test
	rm -f $$PWD/dlc-test-disk0.qcow2

#################################

# Update TODO.md by fetching issues from the main gitea instance API
# requirements: sudo apt install git jq
#               gitea-cli config defined in ~/.config/gitearc
update_todo:
	git clone https://github.com/bashup/gitea-cli gitea-cli
	echo '<!-- This file is automatically generated by "make update_todo" -->' >| doc/md/TODO.md
	echo -e "\n### nodiscc/debian-live-config\n" >> doc/md/TODO.md; \
	./gitea-cli/bin/gitea issues baron/debian-live-config | jq -r '.[] | "- #\(.number) - \(.title) - **`\(.milestone.title // "-")`** `\(.labels | map(.name) | join(","))`"'  | sed 's/ - `null`//' >> doc/md/TODO.md; \
	rm -rf gitea-cli

doc: install_dev_docs doc_package_lists doc_md doc_html

# install documentation generator (sphinx + markdown + theme)
install_dev_docs:
	python3 -m venv .venv/
	source .venv/bin/activate && pip3 install sphinx recommonmark sphinx_rtd_theme

doc_md:
	cp README.md doc/md/index.md
	cp CHANGELOG.md doc/md/
	cp LICENSE doc/md/LICENSE.md
	sed -i 's|doc/md/||g' doc/md/*.md

doc_package_lists:
	./doc/gen_package_lists.py

# HTML documentation generation (sphinx-build --help)
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = doc/md    # répertoire source (markdown)
BUILDDIR      = doc/html  # répertoire destination (html)
doc_html:
	source .venv/bin/activate && sphinx-build -c doc/md -b html doc/md doc/html
