# Windows Platform configuration
message(STATUS "Configuring for Windows platform")

if(MINGW)
    add_compile_options(-mbmi)
endif()

# Set explicit paths for installed gRPC & Protobuf on Windows.
set(CMAKE_PREFIX_PATH "C:/local/grpc" CACHE PATH "" FORCE)
set(gRPC_DIR "C:/local/grpc/lib/cmake/grpc" CACHE PATH "" FORCE) 
set(Protobuf_DIR "C:/local/grpc/lib/cmake/protobuf" CACHE PATH "" FORCE)

# Add any additional Windows-specific settings below.
