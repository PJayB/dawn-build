cmake_minimum_required(VERSION 3.23...3.24 FATAL_ERROR)
project(webgpu-backend-dawn VERSION 1.0.0)

#
# Set up C++ environment
#
set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#
# Include Dawn
#
set(DAWN_BUILD_ANDROID_SAMPLES OFF)
set(DAWN_BUILD_SAMPLES OFF)
set(TINT_BUILD_TESTS OFF)
set(TINT_BUILD_CMD_TOOLS OFF)
set(DAWN_FETCH_DEPENDENCIES ON)
set(DAWN_ENABLE_INSTALL OFF)

add_subdirectory(WebGPU-distribution)

# Ensure dllexport is enabled
#target_compile_definitions(dawn_proc PRIVATE "WGPU_SHARED_LIBRARY")
#target_compile_definitions(dawn_proc PRIVATE "WGPU_SHARED_LIBRARY")
#target_compile_definitions(dawn_native PRIVATE "DAWN_NATIVE_SHARED_LIBRARY")
target_compile_definitions(webgpu_dawn PRIVATE WGPU_IMPLEMENTATION WGPU_SHARED_LIBRARY)

# Find Dawn headers
set(DAWN_HEADER_PATH ${CMAKE_BINARY_DIR}/_deps/dawn-src/include)
set(DAWN_GEN_HEADER_PATH ${CMAKE_BINARY_DIR}/_deps/dawn-build/gen/include)
file(GLOB_RECURSE DAWN_HEADER_FILES
    ${DAWN_HEADER_PATH}/*.h
    ${DAWN_HEADER_PATH}/*.hpp
    ${DAWN_GEN_HEADER_PATH}/*.h
    ${DAWN_GEN_HEADER_PATH}/*.hpp)

# Set final output DLL suffix
# Some platforms define CMAKE_LIBRARY_ARCHITECTURE, some don't.
if ("${CMAKE_LIBRARY_ARCHITECTURE}" STREQUAL "")
    if ("${CMAKE_SYSTEM_NAME}" STREQUAL "")
        message(FATAL_ERROR "CMAKE_SYSTEM_NAME is null")
    endif()
    if ("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "")
        message(FATAL_ERROR "CMAKE_HOST_SYSTEM_PROCESSOR is null")
    endif()
    set(ARCH_SUFFIX "-${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}")
else()
    set(ARCH_SUFFIX "-${CMAKE_LIBRARY_ARCHITECTURE}")
endif()
string(TOLOWER "${ARCH_SUFFIX}" ARCH_SUFFIX)

set(COMPILED_DLL_SUFFIX "${ARCH_SUFFIX}${CMAKE_SHARED_LIBRARY_SUFFIX}" CACHE STRING "The filename suffix for compiled DLLs")

# Output DLL
add_library(webgpu_precompiled SHARED)
target_sources(webgpu_precompiled
    PUBLIC
        webgpu-cpp.cpp
        exports.def
    PUBLIC FILE_SET HEADERS
    BASE_DIRS
        WebGPU-distribution/include
        ${DAWN_HEADER_PATH}
    FILES
        WebGPU-distribution/include/webgpu/webgpu.hpp
        ${DAWN_HEADER_FILES}
)
set_target_properties(webgpu_precompiled PROPERTIES
    OUTPUT_NAME "webgpu-cpp"
    SUFFIX "${COMPILED_DLL_SUFFIX}"
    WINDOWS_EXPORT_ALL_SYMBOLS ON)
target_link_libraries(webgpu_precompiled PUBLIC webgpu)

install(TARGETS webgpu_precompiled FILE_SET HEADERS)
