# CMake generated Testfile for 
# Source directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/sp
# Build directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/sp
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(nng.sp.reconnect_stress_test "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/sp/reconnect_stress_test.exe" "-t" "-v")
set_tests_properties(nng.sp.reconnect_stress_test PROPERTIES  TIMEOUT "180" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/cmake/NNGHelpers.cmake;115;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/sp/CMakeLists.txt;21;nng_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/sp/CMakeLists.txt;0;")
subdirs("protocol")
subdirs("transport")
