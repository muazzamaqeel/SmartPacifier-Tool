cmake_minimum_required(VERSION 3.25)
project(service_backend)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Path to 'external'
set(EXTERNAL_DIR ${CMAKE_SOURCE_DIR}/external)

# Standalone Asio:
include_directories(${EXTERNAL_DIR}/boost_asio/asio/include)
add_definitions(-DASIO_STANDALONE)

# NNG Setup
set(NNG_DIR ${EXTERNAL_DIR}/nng)
add_subdirectory(${NNG_DIR})
include_directories(${NNG_DIR}/include)

# Source files
set(SOURCES
        src/main.cpp
        src/communication_layer/mqtt/mqtt_handler.cpp
        src/communication_layer/mqtt/mqtt_handler.h
        src/nng_ipc/nng_handler.cpp
        src/nng_ipc/nng_handler.h
        )

add_executable(service_backend ${SOURCES})

if (WIN32)
    target_link_libraries(service_backend nng)
else()
    target_link_libraries(service_backend nng pthread)
endif()

set_target_properties(service_backend PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        )
