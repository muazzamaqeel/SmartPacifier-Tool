cmake_minimum_required(VERSION 3.25)
project(service_backend)

set(CMAKE_CXX_STANDARD 17)

# Set relative path for vcpkg
set(VCPKG_DIR "${CMAKE_SOURCE_DIR}/external_libs/vcpkg/installed/x64-windows")

# Include Paho MQTT headers
include_directories(${VCPKG_DIR}/include)
link_directories(${VCPKG_DIR}/lib)

# Add executable
add_executable(service_backend
        main.cpp
        src/broker/brokercheck_os.cpp
        src/broker/mosquitto_logic.cpp
        )

# Link against Paho MQTT C++ library
target_link_libraries(service_backend
        paho-mqttpp3
        paho-mqtt3as
        )

# Copy required DLLs (Windows only)
if(WIN32)
    add_custom_command(TARGET service_backend POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${VCPKG_DIR}/bin/paho-mqtt3as.dll
            ${CMAKE_BINARY_DIR}
            )
endif()
