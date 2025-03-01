cmake_minimum_required(VERSION 3.25)
project(service_backend LANGUAGES CXX)

# Use C++17 (or change to 20/23 if you prefer and your toolchain supports it)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#
# 1. Use the local vcpkg toolchain if no toolchain file is provided
#
#    This triggers "manifest mode" if a vcpkg.json file is present in this directory.
#
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE
            "${CMAKE_CURRENT_SOURCE_DIR}/external/vcpkg/scripts/buildsystems/vcpkg.cmake"
            CACHE STRING "Vcpkg toolchain file" FORCE
            )
endif()

#
# 2. Build the Shared Library for Subscriber (for Flutter FFI)
#
add_library(subscriber SHARED subscriber.cpp subscriber.h)
target_link_libraries(subscriber PRIVATE nng)

if(WIN32)
    target_link_libraries(subscriber PRIVATE ws2_32)
endif()

#
# 3. Build the Publisher Executable
#
add_executable(publisher publisher.cpp)
target_link_libraries(publisher PRIVATE nng)

if(WIN32)
    target_link_libraries(publisher PRIVATE ws2_32)
endif()

#
# 4. (Optional) Build a Static Library with a Simple Function
#
add_library(library STATIC library.cpp library.h)
