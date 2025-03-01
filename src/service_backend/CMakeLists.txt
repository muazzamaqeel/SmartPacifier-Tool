cmake_minimum_required(VERSION 3.25)
project(service_backend)

set(CMAKE_CXX_STANDARD 17)

add_library(service_backend SHARED library.cpp)
