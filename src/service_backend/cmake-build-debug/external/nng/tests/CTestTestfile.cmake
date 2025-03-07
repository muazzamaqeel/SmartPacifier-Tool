# CMake generated Testfile for 
# Source directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests
# Build directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/tests
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(nng.httpclient "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/tests/httpclient.exe" "-v" "-p" "TEST_PORT=13000")
set_tests_properties(nng.httpclient PROPERTIES  TIMEOUT "60" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;57;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;76;add_nng_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;113;add_nng_test1;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;0;")
add_test(nng.wss "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/tests/wss.exe" "-v" "-p" "TEST_PORT=13020")
set_tests_properties(nng.wss PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;57;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;114;add_nng_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;0;")
add_test(nng.cplusplus_pair "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/tests/cplusplus_pair.exe")
set_tests_properties(nng.cplusplus_pair PROPERTIES  TIMEOUT "5" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;68;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;117;add_nng_cpp_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/tests/CMakeLists.txt;0;")
