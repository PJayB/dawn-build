cmake_minimum_required(VERSION 3.23...3.24 FATAL_ERROR)
project(webgpu-precompiled-dawn-test VERSION 1.0.0)

set(CMAKE_MODULE_PATH ../install)
find_package(PrecompiledDawn REQUIRED)

add_executable(test test.cpp)
target_link_libraries(test PUBLIC PrecompiledDawn)
