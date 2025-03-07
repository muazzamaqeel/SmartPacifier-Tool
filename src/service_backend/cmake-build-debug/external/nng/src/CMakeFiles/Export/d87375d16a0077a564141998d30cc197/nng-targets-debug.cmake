#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "nng::nng" for configuration "Debug"
set_property(TARGET nng::nng APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(nng::nng PROPERTIES
  IMPORTED_IMPLIB_DEBUG "${_IMPORT_PREFIX}/lib/nng.lib"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/bin/nng.dll"
  )

list(APPEND _cmake_import_check_targets nng::nng )
list(APPEND _cmake_import_check_files_for_nng::nng "${_IMPORT_PREFIX}/lib/nng.lib" "${_IMPORT_PREFIX}/bin/nng.dll" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
