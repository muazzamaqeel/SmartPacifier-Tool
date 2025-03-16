cmake_minimum_required(VERSION 3.30)
project(sp_backend)

# Set the C++ standard.
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Force building the bundled Paho C library with paho.mqtt.cpp.
set(PAHO_WITH_MQTT_C ON CACHE BOOL "Build the Paho C library as part of Paho MQTT C++ build" FORCE)
set(PAHO_BUILD_EXAMPLES OFF CACHE BOOL "Build the Paho MQTT C++ example apps" FORCE)

# Add the Paho MQTT C++ submodule.
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp)

# Add your main application sources.
add_executable(sp_backend
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/BrokerCheck.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/communication_layer/broker/DataRetrieval.cpp
)

# Set include directories for Paho MQTT.
target_include_directories(sp_backend PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src/external_libs/mqtt/paho.mqtt.cpp/externals/paho-mqtt-c/include
)

# Link your executable against the static Paho MQTT C++ library built in the submodule.
target_link_libraries(sp_backend PRIVATE paho-mqttpp3-static)
