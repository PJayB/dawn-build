FROM ubuntu:jammy

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        pkg-config \
        git \
        python3 \
        libxi-dev \
        libxrandr-dev \
        libxinerama-dev \
        libxcursor-dev \
        mesa-common-dev \
        libx11-xcb-dev \
        cmake \
        build-essential \
        ninja-build \
    ;

