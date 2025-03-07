# CMake generated Testfile for 
# Source directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/platform
# Build directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/platform
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(nng.platform.platform_test "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/platform/platform_test.exe" "-t" "-v")
set_tests_properties(nng.platform.platform_test PROPERTIES  TIMEOUT "180" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/cmake/NNGHelpers.cmake;115;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/platform/CMakeLists.txt;16;nng_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/platform/CMakeLists.txt;0;")
add_test(nng.platform.resolver_test "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/platform/resolver_test.exe" "-t" "-v")
set_tests_properties(nng.platform.resolver_test PROPERTIES  TIMEOUT "180" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/cmake/NNGHelpers.cmake;115;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/platform/CMakeLists.txt;17;nng_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/platform/CMakeLists.txt;0;")
add_test(nng.platform.udp_test "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/platform/udp_test.exe" "-t" "-v")
set_tests_properties(nng.platform.udp_test PROPERTIES  TIMEOUT "180" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/cmake/NNGHelpers.cmake;115;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/platform/CMakeLists.txt;18;nng_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/platform/CMakeLists.txt;0;")
subdirs("posix")
subdirs("windows")
