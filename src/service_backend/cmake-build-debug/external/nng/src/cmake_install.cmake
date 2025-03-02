# Install script for directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/service_backend")
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

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/core/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/platform/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/sp/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/supplemental/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/tools/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/testing/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Library" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY OPTIONAL FILES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/nng.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Tools" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE SHARED_LIBRARY FILES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/nng.dll")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Library" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/nng/nng-targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/nng/nng-targets.cmake"
         "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/CMakeFiles/Export/d87375d16a0077a564141998d30cc197/nng-targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/nng/nng-targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/nng/nng-targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/nng" TYPE FILE FILES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/CMakeFiles/Export/d87375d16a0077a564141998d30cc197/nng-targets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/nng" TYPE FILE FILES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/CMakeFiles/Export/d87375d16a0077a564141998d30cc197/nng-targets-debug.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/../include/nng")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Library" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/nng" TYPE FILE FILES
    "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/nng-config.cmake"
    "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/nng-config-version.cmake"
    "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/cmake/FindMbedTLS.cmake"
    "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/cmake/FindwolfSSL.cmake"
    )
endif()

