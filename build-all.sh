#!/bin/bash
set -eo pipefail

cmake -S . -B build/linux-x86_64 -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake -S . -B build/linux-aarch64 -G Ninja -DCMAKE_BUILD_TYPE=Release --toolchain aarch64-linux-gnu-gcc.cmake

cmake --build build/linux-x86_64
cmake --build build/linux-aarch64

cmake --install build/linux-x86_64 --prefix install
cmake --install build/linux-aarch64 --prefix install
