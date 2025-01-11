FROM ubuntu:jammy

COPY docker/jammy-sources.list /etc/apt/sources.list
COPY docker/config-cmake-apt.bash /usr/local/bin

RUN dpkg --add-architecture arm64 && \
    apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get upgrade -y && \
    apt-get install -y curl gpg lsb-release && \
    /usr/local/bin/config-cmake-apt.bash && \
    apt-get update && \
    apt-get install -y \
        pkg-config \
        git \
        python3 \
        cmake \
        build-essential \
        ninja-build \
        g++-aarch64-linux-gnu \
        libxi-dev \
        libxrandr-dev \
        libxinerama-dev \
        libxcursor-dev \
        mesa-common-dev \
        libx11-xcb-dev \
        libxi-dev:arm64 \
        libxrandr-dev:arm64 \
        libxinerama-dev:arm64 \
        libxcursor-dev:arm64 \
        mesa-common-dev:arm64 \
        libx11-xcb-dev:arm64 \
    ;

