cmake_minimum_required(VERSION 3.23...3.24 FATAL_ERROR)
project(webgpu-precompiled-dawn VERSION 1.0.0)

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
set(DAWN_ENABLE_PIC ON)
set(BUILD_SHARED_LIBS OFF)

add_subdirectory(WebGPU-distribution)

# Find Dawn headers
set(DAWN_HEADER_PATH ${CMAKE_BINARY_DIR}/_deps/dawn-src/include)
set(DAWN_GEN_HEADER_PATH ${CMAKE_BINARY_DIR}/_deps/dawn-build/gen/include)
file(GLOB_RECURSE DAWN_HEADER_FILES
    ${DAWN_HEADER_PATH}/*.h
    ${DAWN_HEADER_PATH}/*.hpp
    ${DAWN_GEN_HEADER_PATH}/*.h
    ${DAWN_GEN_HEADER_PATH}/*.hpp)

# Import our paths
include(FindPrecompiledDawn.cmake)

# Output paths
set(CMAKE_INSTALL_LIBDIR "${PRECOMPILED_DAWN_LIBDIR_BASE}")
set(CMAKE_INSTALL_BINDIR "${PRECOMPILED_DAWN_BINDIR_BASE}")
set(CMAKE_INSTALL_INCLUDEDIR "${PRECOMPILED_DAWN_INCLUDEDIR_BASE}")

# Output DLL
add_library(webgpu_precompiled SHARED)
target_sources(webgpu_precompiled
    PRIVATE
        webgpu-cpp.cpp # Cpp file forces declspec(dllexport)
    PUBLIC FILE_SET HEADERS
    BASE_DIRS
        WebGPU-distribution/include
        ${DAWN_HEADER_PATH}
        ${DAWN_GEN_HEADER_PATH}
    FILES
        WebGPU-distribution/include/webgpu/webgpu.hpp
        ${DAWN_HEADER_FILES}
)
set_target_properties(webgpu_precompiled PROPERTIES
    OUTPUT_NAME "${PRECOMPILED_DAWN_LIBRARY_NAME}"
)

# Steal the webgpu_dawn target's properties and source files
get_target_property(WEBGPU_DAWN_SOURCES webgpu_dawn SOURCES)
get_target_property(WEBGPU_DAWN_COMPILE_OPTIONS webgpu_dawn COMPILE_OPTIONS)
get_target_property(WEBGPU_DAWN_LINK_OPTIONS webgpu_dawn LINK_OPTIONS)
get_target_property(WEBGPU_DAWN_LINK_LIBRARIES webgpu_dawn LINK_LIBRARIES)
target_sources(webgpu_precompiled PRIVATE
    ${WEBGPU_DAWN_SOURCES})
if (WEBGPU_DAWN_COMPILE_OPTIONS)
    target_compile_options(webgpu_precompiled PUBLIC
        ${WEBGPU_DAWN_COMPILE_OPTIONS}
    )
endif()
if (WEBGPU_DAWN_LINK_OPTIONS)
    target_link_options(webgpu_precompiled PUBLIC
        ${WEBGPU_DAWN_LINK_OPTIONS}
    )
endif()
target_link_libraries(webgpu_precompiled PUBLIC
    ${WEBGPU_DAWN_LINK_LIBRARIES}
)
target_compile_definitions(webgpu_precompiled PRIVATE
    "WGPU_IMPLEMENTATION"
    "WGPU_SHARED_LIBRARY")

#
# Set up export properties for each platform
#
if (WIN32)
    set_target_properties(webgpu_precompiled PROPERTIES
        WINDOWS_EXPORT_ALL_SYMBOLS ON
    )
endif()

install(TARGETS webgpu_precompiled
    FILE_SET HEADERS
)

# Install the cmake file
install(FILES FindPrecompiledDawn.cmake DESTINATION ".")
