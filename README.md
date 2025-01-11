To build:
```
git clone --recurse-submodules https://github.com/PJayB/dawn-build.git
cd dawn-build
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
cmake --build build
cmake --install build --prefix install
```

# aarch64
Add `--toolchain aarch64-linux-gnu-gcc.cmake` to the configure step for
`aarch64`.

# Windows Debug Builds
If you're running an application built in Debug, change the configure command
line so that you're building against the matching MSVC runtime library, e.g.:
`-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug`.
