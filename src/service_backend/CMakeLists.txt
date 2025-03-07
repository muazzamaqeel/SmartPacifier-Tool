cmake_minimum_required(VERSION 3.25)
project(service_backend)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ------------------------------------------------------------------
# 1️⃣ Define External Libraries Directory
# ------------------------------------------------------------------
set(EXTERNAL_DIR "${CMAKE_SOURCE_DIR}/external")

# ------------------------------------------------------------------
# 2️⃣ Boost.Asio (Header-only)
# ------------------------------------------------------------------
include_directories("${EXTERNAL_DIR}/boost_asio/asio/include")

# ------------------------------------------------------------------
# 3️⃣ NNG Setup (Build and Link Correctly)
# ------------------------------------------------------------------
set(NNG_SOURCE_DIR "${EXTERNAL_DIR}/nng")
set(NNG_INSTALL_DIR "${EXTERNAL_DIR}/install") # Installed NNG location

# Ensure NNG is built and installed
if(NOT EXISTS "${NNG_INSTALL_DIR}/include/nng/protocol/pubsub0/pub.h")
    message(STATUS "⚠️ NNG not found or missing pub.h! Building it now...")

    # Create build directory for NNG
    file(MAKE_DIRECTORY "${NNG_SOURCE_DIR}/build")

    execute_process(
            COMMAND cmake -G "MinGW Makefiles"
            -DCMAKE_BUILD_TYPE=Release
            -DCMAKE_INSTALL_PREFIX=${NNG_INSTALL_DIR}
            -DNNG_ENABLE_SP_PROTOCOLS=ON
            -DNNG_ENABLE_TLS=OFF
            WORKING_DIRECTORY "${NNG_SOURCE_DIR}/build"
    )

    execute_process(
            COMMAND cmake --build . --config Release
            WORKING_DIRECTORY "${NNG_SOURCE_DIR}/build"
    )

    execute_process(
            COMMAND cmake --install .
            WORKING_DIRECTORY "${NNG_SOURCE_DIR}/build"
    )
endif()

# Include installed NNG headers
include_directories("${NNG_INSTALL_DIR}/include")
link_directories("${NNG_INSTALL_DIR}/lib")

# ------------------------------------------------------------------
# 4️⃣ Mosquitto MQTT Setup
# ------------------------------------------------------------------
set(MOSQUITTO_DEVEL_DIR "C:/Program Files/mosquitto/devel") # Adjust if needed
include_directories("${MOSQUITTO_DEVEL_DIR}")
link_directories("${MOSQUITTO_DEVEL_DIR}")

# ------------------------------------------------------------------
# 5️⃣ Source Files
# ------------------------------------------------------------------
set(SOURCES
        src/main.cpp
        src/ipc/nng/NNGHandler.cpp
        src/ipc/nng/NNGHandler.h
        src/communication_layer/mqtt/MyMQTTClient.cpp
        src/communication_layer/mqtt/MyMQTTClient.h
        )

# ------------------------------------------------------------------
# 6️⃣ Build the Executable
# ------------------------------------------------------------------
add_executable(service_backend ${SOURCES})

# ------------------------------------------------------------------
# 7️⃣ Link Libraries
# ------------------------------------------------------------------
target_link_libraries(service_backend
        PRIVATE
        nng           # Link NNG
        mosquitto     # Link Mosquitto C API
        mosquittopp   # Link Mosquitto C++ wrapper
        )

# ------------------------------------------------------------------
# 8️⃣ Set Output Directory (Optional)
# ------------------------------------------------------------------
set_target_properties(service_backend PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        )

# ------------------------------------------------------------------
# 9️⃣ Debugging Messages
# ------------------------------------------------------------------
message(STATUS "✅ NNG installed at: ${NNG_INSTALL_DIR}")
message(STATUS "✅ Mosquitto installed at: ${MOSQUITTO_DEVEL_DIR}")
message(STATUS "✅ Project source files: ${SOURCES}")
