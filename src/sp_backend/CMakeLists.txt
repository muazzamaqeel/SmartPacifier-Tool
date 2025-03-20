cmake_minimum_required(VERSION 3.30)
project(sp_backend)

# Disable installation rules to avoid export errors.
set(CMAKE_SKIP_INSTALL_RULES ON)

# Disable BoringSSL/OPENSSL assembly routines.
add_definitions(-DBORINGSSL_NO_ASM -DOPENSSL_NO_ASM)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DBORINGSSL_NO_ASM -DOPENSSL_NO_ASM")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBORINGSSL_NO_ASM -DOPENSSL_NO_ASM")

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Lower optimization level in Debug mode and disable aggressive inlining/sibling call optimizations.
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-inline -fno-optimize-sibling-calls")

#
# ---[ Configure the Paho MQTT C++ submodule ]---
#
option(PAHO_WITH_MQTT_C "Build the Paho C library as part of the Paho MQTT C++ build" ON)
option(PAHO_BUILD_EXAMPLES "Build the Paho MQTT C++ example apps" OFF)

#
# ---[ Add the Paho MQTT C++ submodule ]---
#
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp)

#
# ---[ Disable gRPC and Protobuf installation/tests ]---
#
set(gRPC_INSTALL OFF CACHE BOOL "Disable gRPC installation" FORCE)
set(protobuf_INSTALL OFF CACHE BOOL "Disable Protobuf installation" FORCE)
# Let the submodule build protoc so that it matches the Protobuf library.
set(protobuf_BUILD_PROTOC ON CACHE BOOL "Enable building protoc" FORCE)
set(protobuf_BUILD_TESTS OFF CACHE BOOL "Disable building tests" FORCE)
set(RE2_BUILD_TESTING OFF CACHE BOOL "Disable building re2 tests" FORCE)

#
# ---[ Add the gRPC submodule ]---
#
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc)

#
# ---[ (Optional) Force-include <cstdint> for re2/pcre.cc ]---
#
# Uncomment if you still encounter int32_t errors in re2.
# set_source_files_properties(
#     "${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc/third_party/re2/util/pcre.cc"
#     PROPERTIES COMPILE_FLAGS "-include cstdint"
# )

#
# ---[ Main Application ]---
#
add_executable(sp_backend
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/BrokerCheck.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/BrokerCheck.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/DataRetrieval.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/DataRetrieval.h
)

target_include_directories(sp_backend PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/externals/paho-mqtt-c/include
)

target_link_libraries(sp_backend PRIVATE paho-mqttpp3-static)

#
# ---[ gRPC and Protocol Buffers Integration ]---
#
# We let the gRPC submodule build both the Protobuf library and protoc.
set(Protobuf_INCLUDE_DIRS
        "${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/grpc/third_party/protobuf/src"
)

# Specify the proto file directory and file.
set(PROTO_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/ipc")
set(PROTO_FILES "${PROTO_SRC_DIR}/sensor_data.proto")

# Specify the output directory for generated files.
set(GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
file(MAKE_DIRECTORY ${GENERATED_DIR})

# Set output directories for code generation.
set(PROTO_CPP_OUT "${GENERATED_DIR}")
set(GRPC_CPP_OUT "${GENERATED_DIR}")

add_custom_command(
        OUTPUT "${GENERATED_DIR}/sensor_data.pb.cc" "${GENERATED_DIR}/sensor_data.pb.h"
        COMMAND protoc --cpp_out=${PROTO_CPP_OUT} -I ${PROTO_SRC_DIR} ${PROTO_FILES}
        DEPENDS ${PROTO_FILES}
        COMMENT "Generating sensor_data protobuf files..."
)

add_custom_command(
        OUTPUT "${GENERATED_DIR}/sensor_data.grpc.pb.cc" "${GENERATED_DIR}/sensor_data.grpc.pb.h"
        COMMAND protoc --grpc_out=${GRPC_CPP_OUT} --plugin=protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin> -I ${PROTO_SRC_DIR} ${PROTO_FILES}
        DEPENDS ${PROTO_FILES}
        COMMENT "Generating sensor_data gRPC files..."
)

set(GENERATED_SRCS
        "${GENERATED_DIR}/sensor_data.pb.cc"
        "${GENERATED_DIR}/sensor_data.grpc.pb.cc"
)

set(GENERATED_HDRS
        "${GENERATED_DIR}/sensor_data.pb.h"
        "${GENERATED_DIR}/sensor_data.grpc.pb.h"
)

target_include_directories(sp_backend PRIVATE ${GENERATED_DIR})
target_sources(sp_backend PRIVATE ${GENERATED_SRCS})

target_link_libraries(sp_backend PRIVATE
        grpc++
        protobuf::libprotobuf
)
