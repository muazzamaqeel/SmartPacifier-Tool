# CMake generated Testfile for 
# Source directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/tools/perf
# Build directory: C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/tools/perf
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(nng.inproc_lat "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/tools/perf/inproc_lat.exe" "64" "10000")
set_tests_properties(nng.inproc_lat PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/tools/perf/CMakeLists.txt;27;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/tools/perf/CMakeLists.txt;0;")
add_test(nng.inproc_thr "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/cmake-build-debug/external/nng/src/tools/perf/inproc_thr.exe" "1400" "10000")
set_tests_properties(nng.inproc_thr PROPERTIES  TIMEOUT "30" _BACKTRACE_TRIPLES "C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/tools/perf/CMakeLists.txt;30;add_test;C:/programming/TeamOrientedProject---Smart-Pacifier/src/service_backend/external/nng/src/tools/perf/CMakeLists.txt;0;")
