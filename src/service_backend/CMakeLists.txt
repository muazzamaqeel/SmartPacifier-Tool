cmake_minimum_required(VERSION 3.25)
project(service_backend LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ------------------------------------------------------------------------------
# 1. Define External Libraries Directory
# ------------------------------------------------------------------------------
set(EXTERNAL_DIR "${CMAKE_SOURCE_DIR}/external")

# ------------------------------------------------------------------------------
# 2. Boost.Asio (Header-only)
# ------------------------------------------------------------------------------
include_directories("${EXTERNAL_DIR}/boost_asio/asio/include")

# ------------------------------------------------------------------------------
# 3. NNG Setup (Build and Link Correctly)
# ------------------------------------------------------------------------------
set(NNG_SOURCE_DIR "${EXTERNAL_DIR}/nng")
set(NNG_INSTALL_DIR "${EXTERNAL_DIR}/install")  # Path where NNG is installed

# Check for a key NNG header (pub.h). If not found, build & install NNG.
if(NOT EXISTS "${NNG_INSTALL_DIR}/include/nng/protocol/pubsub0/pub.h")
    message(STATUS "⚠️ NNG not found in ${NNG_INSTALL_DIR}; building and installing NNG...")

    # Create the build directory for NNG
    file(MAKE_DIRECTORY "${NNG_SOURCE_DIR}/build")

    # Use the same generator as the main project to avoid mismatches.
    set(NNG_GENERATOR "${CMAKE_GENERATOR}")

    # For multi-configuration generators (like Visual Studio), omit CMAKE_BUILD_TYPE.
    if(CMAKE_GENERATOR MATCHES "Visual Studio")
        set(BUILD_TYPE_OPTION "")
    else()
        set(BUILD_TYPE_OPTION "-DCMAKE_BUILD_TYPE=Release")
    endif()

    message(STATUS "Using generator for NNG: ${NNG_GENERATOR}")

    # Configure NNG using the same generator
    execute_process(
            COMMAND cmake -G "${NNG_GENERATOR}" ${BUILD_TYPE_OPTION}
            -DCMAKE_INSTALL_PREFIX=${NNG_INSTALL_DIR}
            -DNNG_ENABLE_SP_PROTOCOLS=ON
            -DNNG_ENABLE_TLS=OFF
            ${NNG_SOURCE_DIR}
            WORKING_DIRECTORY "${NNG_SOURCE_DIR}/build"
            RESULT_VARIABLE CONFIG_RESULT
    )
    if(NOT CONFIG_RESULT EQUAL 0)
        message(FATAL_ERROR "Error configuring NNG")
    endif()

    # Build NNG (use --config Release for multi-configuration generators)
    execute_process(
            COMMAND cmake --build . --config Release
            WORKING_DIRECTORY "${NNG_SOURCE_DIR}/build"
            RESULT_VARIABLE BUILD_RESULT
    )
    if(NOT BUILD_RESULT EQUAL 0)
        message(FATAL_ERROR "Error building NNG")
    endif()

    # Install NNG
    execute_process(
            COMMAND cmake --install . --config Release
            WORKING_DIRECTORY "${NNG_SOURCE_DIR}/build"
            RESULT_VARIABLE INSTALL_RESULT
    )
    if(NOT INSTALL_RESULT EQUAL 0)
        message(FATAL_ERROR "Error installing NNG")
    endif()
endif()

# Add NNG include directory.
include_directories("${NNG_INSTALL_DIR}/include")

# ------------------------------------------------------------------------------
# 4. Mosquitto MQTT Setup
# ------------------------------------------------------------------------------
# Adjust this path if needed. Your Mosquitto installation appears under "C:/Program Files/mosquitto/devel".
set(MOSQUITTO_DEVEL_DIR "C:/Program Files/mosquitto/devel")
include_directories("${MOSQUITTO_DEVEL_DIR}")
link_directories("${MOSQUITTO_DEVEL_DIR}")

# ------------------------------------------------------------------------------
# 5. Source Files
# ------------------------------------------------------------------------------
set(SOURCES
        src/main.cpp
        src/ipc/nng/NNGHandler.cpp
        src/ipc/nng/NNGHandler.h
        src/communication_layer/mqtt/MyMQTTClient.cpp
        src/communication_layer/mqtt/MyMQTTClient.h
        )

# ------------------------------------------------------------------------------
# 6. Build the Executable
# ------------------------------------------------------------------------------
add_executable(service_backend ${SOURCES})

# ------------------------------------------------------------------------------
# 7. Link Libraries
# ------------------------------------------------------------------------------
# Instead of linking by name, we now explicitly link to the static library file.
target_link_libraries(service_backend PRIVATE
        "${NNG_INSTALL_DIR}/lib/libnng.a"  # Link NNG (static library)
        mosquitto                         # Mosquitto C API
        mosquittopp                       # Mosquitto C++ wrapper
        )

# ------------------------------------------------------------------------------
# 8. Set Output Directory (Optional)
# ------------------------------------------------------------------------------
set_target_properties(service_backend PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        )

# ------------------------------------------------------------------------------
# 9. Debugging Messages
# ------------------------------------------------------------------------------
message(STATUS "✅ NNG installed at: ${NNG_INSTALL_DIR}")
message(STATUS "✅ Mosquitto installed at: ${MOSQUITTO_DEVEL_DIR}")
message(STATUS "✅ Project source files: ${SOURCES}")
