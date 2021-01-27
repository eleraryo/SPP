# Minimum version of CMake required to build this project
cmake_minimum_required(VERSION 3.8.2)
enable_language(CUDA)

# Name of the project
project(Praktikum3)

# Add all the source files needed to build the executable
add_executable(
  biliteral
  main.cpp
  serial.cpp
  kernel.cu
  ppm.cpp
  ppm.h
)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set_property(TARGET biliteral PROPERTY CUDA_STANDARD 11)
set_property(TARGET biliteral PROPERTY CUDA_ARCHITECTURES 52)
