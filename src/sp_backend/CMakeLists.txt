cmake_minimum_required(VERSION 3.30)
project(sp_backend)

# Set the C++ standard.
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# If using MinGW, add the BMI flag to enable __builtin_ctzs.
if(MINGW)
    add_compile_options(-mbmi)
endif()

# Disable installation of protobuf, Abseil, and gRPC targets to avoid export errors.
set(protobuf_INSTALL OFF CACHE BOOL "Disable installation of protobuf targets" FORCE)
set(ABSL_ENABLE_INSTALL OFF CACHE BOOL "Disable installation of Abseil targets" FORCE)
set(gRPC_INSTALL OFF CACHE BOOL "Disable installation of gRPC targets" FORCE)

# Use system OpenSSL instead of building BoringSSL.
set(gRPC_SSL_PROVIDER "package" CACHE STRING "Use system OpenSSL" FORCE)

# (Optional) If CMake cannot automatically locate your OpenSSL, uncomment and adjust the following:
# set(OPENSSL_ROOT_DIR "C:/msys64/mingw64" CACHE PATH "" FORCE)
# set(OPENSSL_INCLUDE_DIR "C:/msys64/mingw64/include" CACHE PATH "" FORCE)
# set(OPENSSL_SSL_LIBRARY "C:/msys64/mingw64/lib/libssl.a" CACHE FILEPATH "" FORCE)
# set(OPENSSL_CRYPTO_LIBRARY "C:/msys64/mingw64/lib/libcrypto.a" CACHE FILEPATH "" FORCE)

# Force building the bundled Paho C library with paho.mqtt.cpp.
set(PAHO_WITH_MQTT_C ON CACHE BOOL "Build the Paho C library as part of Paho MQTT C++ build" FORCE)
set(PAHO_BUILD_EXAMPLES OFF CACHE BOOL "Build the Paho MQTT C++ example apps" FORCE)

# Add the Paho MQTT C++ submodule.
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp)

# Add the gRPC submodule.
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc)

# Add your main application sources.
add_executable(sp_backend
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/BrokerCheck.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/DataRetrieval.cpp
        src/ipc_layer/grpc/gprc_server.cpp
        src/ipc_layer/grpc/gprc_server.h
        src/communication_layer/broker/GlobalMessageQueue.h
        src/communication_layer/broker/Logger.cpp
        src/communication_layer/broker/Logger.h
)

# Set include directories for Paho MQTT and gRPC.
target_include_directories(sp_backend PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/externals/paho-mqtt-c/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc/third_party/protobuf/src
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc/third_party/protobuf/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc/third_party/abseil-cpp
)

# Link your executable against the static Paho MQTT C++ and gRPC libraries.
target_link_libraries(sp_backend PRIVATE
        grpc++
        grpc
        paho-mqttpp3-static
)
