cmake_minimum_required(VERSION 3.25)
project(service_backend)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ------------------------------------------------------------------
# 1) External Libraries: Asio and NNG
# ------------------------------------------------------------------
set(EXTERNAL_DIR "${CMAKE_SOURCE_DIR}/external")

# Asio (header-only)
include_directories("${EXTERNAL_DIR}/boost_asio/asio/include")

# NNG (assumed to have its own CMakeLists.txt)
set(NNG_DIR "${EXTERNAL_DIR}/nng")
add_subdirectory("${NNG_DIR}")
include_directories("${NNG_DIR}/include")

# ------------------------------------------------------------------
# 2) Mosquitto Setup (using the C and/or C++ API)
# ------------------------------------------------------------------
# Point to the Mosquitto development files in the devel folder.
set(MOSQUITTO_DEVEL_DIR "C:/Program Files/mosquitto/devel")
include_directories("${MOSQUITTO_DEVEL_DIR}")
link_directories("${MOSQUITTO_DEVEL_DIR}")

# ------------------------------------------------------------------
# 3) Source Files
# ------------------------------------------------------------------
set(SOURCES
        src/main.cpp
        src/nng_ipc/NNGHandler.cpp
        src/nng_ipc/NNGHandler.h
        src/communication_layer/mqtt/MyMQTTClient.cpp
        src/communication_layer/mqtt/MyMQTTClient.h
        )

# ------------------------------------------------------------------
# 4) Build the Executable
# ------------------------------------------------------------------
add_executable(service_backend ${SOURCES})

# ------------------------------------------------------------------
# 5) Link Libraries
# ------------------------------------------------------------------
target_link_libraries(service_backend
        PRIVATE
        nng
        mosquitto      # C API library
        mosquittopp    # C++ wrapper library
        )

# ------------------------------------------------------------------
# 6) Set Output Directory (Optional)
# ------------------------------------------------------------------
set_target_properties(service_backend PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        )
