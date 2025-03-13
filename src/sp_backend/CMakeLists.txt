cmake_minimum_required(VERSION 3.30)
project(sp_backend)

set(CMAKE_CXX_STANDARD 17)

#
# ---[ Configure the Paho MQTT C++ submodule ]---
# These options ensure paho.mqtt.cpp also builds the C library.
#
option(PAHO_WITH_MQTT_C "Build the Paho C library as part of the Paho MQTT C++ build" ON)
option(PAHO_BUILD_EXAMPLES "Build the Paho MQTT C++ example apps" OFF)  # Turn off unless you need them

#
# ---[ Add paho.mqtt.cpp subdirectory ]---
# Adjust the path if the submodule is in a different location.
#
add_subdirectory(src/external_libs/mqtt/paho.mqtt.cpp)

#
# ---[ Main Application ]---
#
add_executable(sp_backend src/main.cpp
        src/communication_layer/broker/BrokerCheck.cpp
        src/communication_layer/broker/BrokerCheck.h
        src/communication_layer/broker/DataRetrieval.cpp
        src/communication_layer/broker/DataRetrieval.h)

#
# ---[ Link to the Paho MQTT C++ library ]---
# By default, paho.mqtt.cpp produces:
#   - paho-mqttpp3        (shared library)
#   - paho-mqttpp3-static (static library)
#
# Choose whichever fits your needs. For a static link:
#
target_link_libraries(sp_backend PRIVATE paho-mqttpp3-static)

# Or for a dynamic (shared) library link, do:
# target_link_libraries(sp_backend PRIVATE paho-mqttpp3)
