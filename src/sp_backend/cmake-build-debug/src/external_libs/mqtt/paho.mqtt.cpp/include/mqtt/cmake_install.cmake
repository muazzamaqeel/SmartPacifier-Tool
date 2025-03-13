# Install script for directory: C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/sp_backend")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "C:/Program Files/JetBrains/CLion 2024.3.4/bin/mingw/bin/objdump.exe")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/mqtt" TYPE FILE FILES
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/async_client.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/buffer_ref.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/buffer_view.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/callback.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/client.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/connect_options.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/create_options.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/delivery_token.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/disconnect_options.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/event.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/exception.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/export.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/iaction_listener.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/iasync_client.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/iclient_persistence.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/message.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/platform.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/properties.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/reason_code.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/response_options.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/server_response.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/ssl_options.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/string_collection.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/subscribe_options.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/thread_queue.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/token.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/topic_matcher.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/topic.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/types.h"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp/include/mqtt/will_options.h"
    )
endif()

