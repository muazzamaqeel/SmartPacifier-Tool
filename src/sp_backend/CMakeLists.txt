cmake_minimum_required(VERSION 3.30)
project(sp_backend)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#
# ---[ Configure the Paho MQTT C++ submodule ]---
# These options ensure that paho.mqtt.cpp also builds the Paho C library.
#
option(PAHO_WITH_MQTT_C "Build the Paho C library as part of the Paho MQTT C++ build" ON)
option(PAHO_BUILD_EXAMPLES "Build the Paho MQTT C++ example apps" OFF)  # Turn off unless you need them

#
# ---[ Add the Paho MQTT C++ submodule ]---
# Adjust the path if the submodule is in a different location.
#
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp)

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

#
# ---[ Set include directories for Paho MQTT ]---
# This allows you to use #include <mqtt/async_client.h> in your code.
#
target_include_directories(sp_backend PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/externals/paho-mqtt-c/include
)

#
# ---[ Link to the Paho MQTT C++ library ]---
# By default, paho.mqtt.cpp produces:
#   - paho-mqttpp3        (shared library)
#   - paho-mqttpp3-static (static library)
#
# Here, we link the static library. If you prefer the shared version, change to paho-mqttpp3.
#
target_link_libraries(sp_backend PRIVATE paho-mqttpp3-static)
