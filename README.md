# Precompiled Dawn Builds

This repo provides a utility script to create `libwebgpu_dawn.so` or
`webgpu_dawn.dll` for use with projects. There are important differences between
the way this library is produced versus stock Dawn:

* The version of Dawn is locked to `chromium/6536`, in order to exactly match
  with Elie Michel's fanstastic
  [WebGPU-Cpp](https://github.com/eliemichel/WebGPU-Cpp) library.
* This only produces a single, shared library. By default, Dawn will output all
  its dependent libraries as either static or shared, and thus, distributing a
  single dynamic library with your application would be impossible.

## Using the Library

To link against the precompiled library:

* Download a release from this repo's Releases page and extract it somewhere
* In your CMake project, add the path to `CMAKE_MODULE_PATH`
* `find_package(PrecompiledDawn REQUIRED)`
* `target_link_libraries(YourApp PUBLIC PrecompiledDawn)`

OS, target architecture and MSVC runtime (if applicable) are automatically
detected, but can be overriden with these cache variables if needed:

```
PRECOMPILED_DAWN_SYSTEM_NAME
PRECOMPILED_DAWN_SYSTEM_PROCESSOR
PRECOMPILED_DAWN_RUNTIME_LIBRARY
```

## Building the Library

CMake 3.23 or higher is required.

You will also need Dawn's build dependencies installed (see
[Building](https://dawn.googlesource.com/dawn/+/HEAD/docs/building.md)).

Alternatively, on Linux, you can use the provided [Dockerfile] to create a
Docker or Podman image that is preconfigured for building the library.

### Building All Targets

On Linux, run `build-all.sh`. On Windows, run `build-all.bat`.

### Building a Specific Target
To build a specific target:
```
git clone --recurse-submodules https://github.com/PJayB/dawn-build.git
cd dawn-build
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
cmake --build build
cmake --install build --prefix install
```

For Linux `aarch64`, add `--toolchain aarch64-linux-gnu-gcc.cmake` to the
configure step.

If you're running Windows, you should also ensure the MSVC runtime library
matches the application you're linking against. For example, if you're building
Debug, use `-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug`.
