FROM debian:bookworm

# enable contrib, non-free and non-free-firmware
# required to find packages like rar
RUN sed -i 's/Components: main/& contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources

# enable installation of multiarch binaries
# required to find packages like linux-headers-686:i386
RUN dpkg --add-architecture i386

# install packages required to build the image
RUN apt update && apt -y install make sudo

# copy source files to the container
COPY . /build

# install build dependencies in the container
RUN cd /build && make install_buildenv

# build the image
RUN cd /build && make
