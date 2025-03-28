cmake_minimum_required(VERSION 3.10)
project(sp_backend)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(MINGW)
    add_compile_options(-mbmi)
endif()

# ---[ 1. Remove local gRPC build ]---
# Do not build the local gRPC submodule since we use the installed version.
# add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc)

# ---[ 2. Find installed gRPC & Protobuf ]---
# Point CMake to your installed gRPC (and its bundled Protobuf) in C:/local/grpc.
set(CMAKE_PREFIX_PATH "C:/local/grpc" CACHE PATH "" FORCE)
set(gRPC_DIR "C:/local/grpc/lib/cmake/grpc" CACHE PATH "" FORCE)
set(Protobuf_DIR "C:/local/grpc/lib/cmake/protobuf" CACHE PATH "" FORCE)

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
        src/ipc_layer/grpc/gprc_server.h
        src/communication_layer/broker/GlobalMessageQueue.h
        src/communication_layer/broker/Logger.cpp
        src/communication_layer/broker/Logger.h
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
