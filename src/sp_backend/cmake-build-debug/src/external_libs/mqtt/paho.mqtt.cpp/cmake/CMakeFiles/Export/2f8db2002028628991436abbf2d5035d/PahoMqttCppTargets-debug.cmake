#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "PahoMqttCpp::paho-mqtt3a-static" for configuration "Debug"
set_property(TARGET PahoMqttCpp::paho-mqtt3a-static APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(PahoMqttCpp::paho-mqtt3a-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libpaho-mqtt3a-static.a"
  )

list(APPEND _cmake_import_check_targets PahoMqttCpp::paho-mqtt3a-static )
list(APPEND _cmake_import_check_files_for_PahoMqttCpp::paho-mqtt3a-static "${_IMPORT_PREFIX}/lib/libpaho-mqtt3a-static.a" )

# Import target "PahoMqttCpp::paho-mqttpp3-static" for configuration "Debug"
set_property(TARGET PahoMqttCpp::paho-mqttpp3-static APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(PahoMqttCpp::paho-mqttpp3-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libpaho-mqttpp3-static.a"
  )

list(APPEND _cmake_import_check_targets PahoMqttCpp::paho-mqttpp3-static )
list(APPEND _cmake_import_check_files_for_PahoMqttCpp::paho-mqttpp3-static "${_IMPORT_PREFIX}/lib/libpaho-mqttpp3-static.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
