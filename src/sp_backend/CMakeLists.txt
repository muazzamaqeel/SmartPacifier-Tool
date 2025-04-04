cmake_minimum_required(VERSION 3.10)
project(sp_backend)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ---[ Platform-Specific Configuration ]---
# Detect the operating system and include the appropriate platform file.
if(WIN32)
    message(STATUS "Configuring for Windows")
    include(${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/windows/Platform.cmake)
elseif(UNIX AND NOT APPLE)
    message(STATUS "Configuring for Linux")
    include(${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/linux/Platform.cmake)
elseif(APPLE)
    # For demonstration, we assume that if IOS is defined then it's iOS; otherwise macOS.
    if(IOS)
        message(STATUS "Configuring for iOS")
        include(${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/ios/Platform.cmake)
    else()
        message(STATUS "Configuring for macOS")
        include(${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/ios/Platform.cmake)
    endif()
elseif(ANDROID)
    message(STATUS "Configuring for Android")
    include(${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/android/Platform.cmake)
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

# ---[ 1. Remove local gRPC build ]---
# Do not build the local gRPC submodule since we use the installed version.
# add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc)

# ---[ 2. Find installed gRPC & Protobuf ]---
# Windows-specific paths have been moved to the platform file.
find_package(Protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)

# ---[ 3. Build Paho from submodule (optional) ]---
set(PAHO_WITH_MQTT_C ON CACHE BOOL "Build the Paho C library as part of Paho MQTT C++ build" FORCE)
set(PAHO_BUILD_EXAMPLES OFF CACHE BOOL "Build the Paho MQTT C++ example apps" FORCE)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp)

# ---[ 4. Add your main executable ]---
add_executable(sp_backend
        src/main.cpp
        src/communication_layer/broker/BrokerCheck.cpp
        src/communication_layer/broker/DataRetrieval.cpp
        src/ipc_layer/grpc/gprc_server.cpp
        src/ipc_layer/grpc/myservice.pb.cc
        src/ipc_layer/grpc/myservice.grpc.pb.cc
        src/ipc_layer/grpc/sensor_data.pb.cc   # <-- Generated file for sensor_data.proto
        src/ipc_layer/grpc/gprc_server.h
        src/communication_layer/broker/GlobalMessageQueue.h
        src/communication_layer/broker/Logger.cpp
        src/communication_layer/broker/Logger.h
        src/platform_layer/PlatformManager.h
        src/platform_layer/linux/LinuxPlatformManager.h
        src/platform_layer/PlatformFactory.h
        src/platform_layer/windows/WindowsPlatformManager.cpp
        src/platform_layer/windows/WindowsPlatformManager.h
)

# ---[ 5. Include directories ]---
target_include_directories(sp_backend PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/externals/paho-mqtt-c/include
        ${Protobuf_INCLUDE_DIRS}  # Use the include directories provided by the installed Protobuf
)

# ---[ 6. Link libraries ]---
target_link_libraries(sp_backend PRIVATE
        gRPC::grpc++
        gRPC::grpc
        protobuf::libprotobuf
        paho-mqttpp3-static
)
