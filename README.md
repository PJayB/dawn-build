To build:
```
git clone --recurse-submodules https://github.com/PJayB/dawn-build.git
cd dawn-build
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
cmake --install build --prefix install
```
Add `--toolchain aarch64-linux-gnu-gcc.cmake` to the configure step for `aarch64`.
