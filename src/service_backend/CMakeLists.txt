cmake_minimum_required(VERSION 3.25)
project(service_backend)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Clone Boost.Asio & NNG inside external/
set(EXTERNAL_DIR ${CMAKE_SOURCE_DIR}/external)

# ---------------------- Boost.Asio Setup (Header-Only) ----------------------
include_directories(${EXTERNAL_DIR}/boost_asio/asio/include)

# ---------------------- NNG Setup ----------------------
# Clone NNG in external/ and build it
set(NNG_DIR ${EXTERNAL_DIR}/nng)
add_subdirectory(${NNG_DIR})

include_directories(${NNG_DIR}/include)

# ---------------------- Source Files ----------------------
set(SOURCES
        src/main.cpp
        src/mqtt_handler.cpp
        src/mqtt_handler.h
        src/nng_handler.cpp
        src/nng_handler.h
        )

# ---------------------- Build Executable ----------------------
add_executable(service_backend ${SOURCES})
if (WIN32)
    target_link_libraries(service_backend nng)
else()
    target_link_libraries(service_backend nng pthread)
endif()

# ---------------------- Set Output Directories ----------------------
set_target_properties(service_backend PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        )
