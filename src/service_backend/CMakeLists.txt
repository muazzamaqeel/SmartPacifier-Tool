cmake_minimum_required(VERSION 3.25)
project(service_backend)

# Use C++17 (or change to 20/23 if you prefer and your toolchain supports it)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# === Build the Shared Library for Subscriber (for Flutter FFI) ===
add_library(subscriber SHARED subscriber.cpp subscriber.h)

# Link the NNG library. Adjust the path if necessary.
target_link_libraries(subscriber PRIVATE nng)
if(WIN32)
    target_link_libraries(subscriber PRIVATE ws2_32)
endif()

# === Build the Publisher Executable ===
add_executable(publisher publisher.cpp)
target_link_libraries(publisher PRIVATE nng)
if(WIN32)
    target_link_libraries(publisher PRIVATE ws2_32)
endif()

# === Optional: Build a Static Library with a Simple Function ===
add_library(library STATIC library.cpp library.h)
