# Install script for directory: C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs

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
  set(CMAKE_OBJDUMP "C:/msys64/mingw64/bin/objdump.exe")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/man/man3" TYPE FILE FILES
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_cancel.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_create_query.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_destroy.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_destroy_options.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_dup.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_expand_name.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_expand_string.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_fds.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_free_data.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_free_hostent.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_free_string.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_freeaddrinfo.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_get_servers.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_get_servers_ports.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_getaddrinfo.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_gethostbyaddr.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_gethostbyname.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_gethostbyname_file.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_getnameinfo.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_getsock.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_inet_ntop.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_inet_pton.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_init.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_init_options.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_library_cleanup.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_library_init.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_library_init_android.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_library_initialized.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_mkquery.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_a_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_aaaa_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_caa_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_mx_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_naptr_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_ns_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_ptr_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_soa_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_srv_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_parse_txt_reply.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_process.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_query.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_save_options.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_search.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_send.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_local_dev.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_local_ip4.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_local_ip6.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_servers.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_servers_csv.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_servers_ports.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_servers_ports_csv.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_socket_callback.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_socket_configure_callback.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_socket_functions.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_set_sortlist.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_strerror.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_timeout.3"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ares_version.3"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Tools" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/man/man1" TYPE FILE FILES
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/acountry.1"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/adig.1"
    "C:/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/cares/cares/docs/ahost.1"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Programming/SmartPacifier-Tool/src/sp_backend/cmake-build-debug/src/external_libs/grpc/third_party/cares/cares/docs/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
