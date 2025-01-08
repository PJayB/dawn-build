To build:
```
git submodule update --init
cmake -S . -B build -G Ninja
cmake --build build
cmake --install build --prefix install
```
Add `--toolchain aarch64-linux-gnu-gcc.cmake` to the configure step for `aarch64`.
