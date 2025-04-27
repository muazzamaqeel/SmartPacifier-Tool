cmake_minimum_required(VERSION 3.28)
project(sp_backend LANGUAGES CXX)

# ——————————————————————————————————————————————
# 1) C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ——————————————————————————————————————————————
# 2) Platform‐Specific Configuration
if(WIN32)
    message(STATUS "Configuring for Windows")
    include(${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/windows/Platform.cmake)
elseif(UNIX AND NOT APPLE)
    message(STATUS "Configuring for Linux")
    include(${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/linux/Platform.cmake)
elseif(APPLE)
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

# ——————————————————————————————————————————————
# 3) Find installed gRPC & Protobuf
find_package(Protobuf    CONFIG REQUIRED)
find_package(gRPC        CONFIG REQUIRED)

# ——————————————————————————————————————————————
# 4) Build Paho MQTT C++ (with bundled C)
set(PAHO_WITH_MQTT_C    ON  CACHE BOOL "" FORCE)
set(PAHO_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp)

# ——————————————————————————————————————————————
# 5) Locate protoc & grpc_cpp_plugin
find_program(PROTOC_EXECUTABLE
        NAMES protoc
        HINTS "C:/local/grpc/bin" ENV PATH
        REQUIRED
)
find_program(GRPC_CPP_PLUGIN_EXECUTABLE
        NAMES grpc_cpp_plugin.exe grpc_cpp_plugin
        HINTS "C:/local/grpc/bin" ENV PATH
        REQUIRED
)

# ——————————————————————————————————————————————
# 6) Auto‐generate .pb / .grpc.pb sources
set(PROTO_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/ipc_layer/grpc")
set(PROTOS
        "${PROTO_SRC_DIR}/myservice.proto"
        "${PROTO_SRC_DIR}/sensor_data.proto"
)

set(GEN_OUT "${PROTO_SRC_DIR}")
foreach(p ${PROTOS})
    get_filename_component(name ${p} NAME_WE)
    list(APPEND GEN_SRCS "${GEN_OUT}/${name}.pb.cc"  "${GEN_OUT}/${name}.grpc.pb.cc")
    list(APPEND GEN_HDRS "${GEN_OUT}/${name}.pb.h"   "${GEN_OUT}/${name}.grpc.pb.h")
endforeach()

add_custom_command(
        OUTPUT ${GEN_SRCS} ${GEN_HDRS}
        COMMAND ${PROTOC_EXECUTABLE}
        --proto_path=${PROTO_SRC_DIR}
        --cpp_out=${GEN_OUT}
        ${PROTOS}
        COMMAND ${PROTOC_EXECUTABLE}
        --proto_path=${PROTO_SRC_DIR}
        --grpc_out=${GEN_OUT}
        --plugin=protoc-gen-grpc=${GRPC_CPP_PLUGIN_EXECUTABLE}
        ${PROTOS}
        DEPENDS ${PROTOS}
        COMMENT "Generating Protobuf + gRPC sources"
        VERBATIM
)

add_custom_target(generate_protos ALL
        DEPENDS ${GEN_SRCS} ${GEN_HDRS}
)

# ——————————————————————————————————————————————
# 7) Declare the executable
add_executable(sp_backend
        ${GEN_SRCS}
        src/main.cpp
        src/communication_layer/broker/BrokerCheck.cpp
        src/communication_layer/broker/DataRetrieval.cpp
        src/communication_layer/broker/Logger.cpp
        src/communication_layer/CommunicationLayer.cpp
        src/ipc_layer/grpc/gprc_server.cpp
        src/platform_layer/windows/WindowsPlatformManager.cpp
        src/platform_layer/linux/LinuxPlatformManager.cpp
)

add_dependencies(sp_backend generate_protos)

# ——————————————————————————————————————————————
# 8) Include paths
target_include_directories(sp_backend PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker
        ${CMAKE_CURRENT_SOURCE_DIR}/src/ipc_layer/grpc
        ${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer
        ${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/windows
        ${CMAKE_CURRENT_SOURCE_DIR}/src/platform_layer/linux
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/externals/paho-mqtt-c/include
)

# ——————————————————————————————————————————————
# 9) Link libraries
target_link_libraries(sp_backend PRIVATE
        gRPC::grpc++
        gRPC::grpc
        protobuf::libprotobuf
        paho-mqttpp3-static
)
