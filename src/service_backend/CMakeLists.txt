cmake_minimum_required(VERSION 3.25)
project(service_backend)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Show a helpful message for Debug builds
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "Debug build - Ensure debug DLLs are present!")
endif()

# Set relative paths for vcpkg
set(VCPKG_DIR "${CMAKE_SOURCE_DIR}/src/external_libs/vcpkg/installed/x64-windows")
include_directories(${VCPKG_DIR}/include)
link_directories(${VCPKG_DIR}/lib)

# Define the executable
add_executable(service_backend
        main.cpp
        src/broker/brokercheck_os.cpp
        src/broker/mqtt_subscriber.cpp
        )

# Only link the C version of Paho MQTT (No C++ version found)
target_link_libraries(service_backend
        paho-mqtt3a
        paho-mqtt3as
        paho-mqtt3c
        paho-mqtt3cs
        )
