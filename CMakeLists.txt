cmake_minimum_required(VERSION 3.23...3.24 FATAL_ERROR)
project(webgpu-backend-dawn VERSION 1.0.0)

set(DAWN_FETCH_DEPENDENCIES ON)
set(DAWN_ENABLE_INSTALL OFF)
set(CMAKE_BUILD_TYPE Release)

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

add_subdirectory(WebGPU-distribution)

set(DAWN_HEADER_PATH ${CMAKE_BINARY_DIR}/_deps/dawn-src/include)
file(GLOB_RECURSE DAWN_HEADER_FILES
    ${DAWN_HEADER_PATH}/*.h
    ${DAWN_HEADER_PATH}/*.hpp)

add_library(webgpu_precompiled SHARED)
target_sources(webgpu_precompiled
    PUBLIC
        webgpu-cpp.cpp
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
