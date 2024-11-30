FROM debian:bookworm

WORKDIR /tmp/workspace

# enable contrib, non-free and non-free-firmware
# required to find packages like rar
RUN sed -i 's/Components: main/& contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources

# enable installation of multiarch binaries
# required to find packages like linux-headers-686:i386
RUN dpkg --add-architecture i386

# install packages required to build the image
RUN apt update && apt -y install \
	apt-transport-https \
	build-essential \
	colordiff \
	git \
	gnupg \
	live-build \
	make \
	ovmf \
	python3-apt \
	python3-venv \
	rename \
	rsync \
	sudo \
	unzip \
	wget

# trust the temporary workspace directory
RUN git config --global --add safe.directory /tmp/workspace

# remove 'download_extra' to build without third party software/dotfiles
CMD ["make", "doc", "download_extra", "build"]
