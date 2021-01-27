# Minimum version of CMake required to build this project
cmake_minimum_required(VERSION 3.17)
# Name of the project
project(Praktikum3)
enable_language(CUDA)

find_package(CUDAToolkit)

# Add all the source files needed to build the executable
add_executable(
  bilateral
  main.cpp
  serial.cpp
  kernel.cu
  ppm.cpp
  ppm.h
)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set_property(TARGET bilateral PROPERTY CUDA_STANDARD 11)
set_property(TARGET bilateral PROPERTY CUDA_ARCHITECTURES 52)

target_link_libraries(bilateral PRIVATE CUDA::cudart)
