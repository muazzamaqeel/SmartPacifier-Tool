# Linux Platform configuration
message(STATUS "Configuring for Linux platform")
# Adding extra compile warnings for Linux.
add_compile_options(-Wall -Wextra -Wpedantic)

# TODO (basti, muazzam): check build process on linux and modify below paths accordingly.

# set(CMAKE_PREFIX_PATH "/usr/local/grpc" CACHE PATH "" FORCE)
# set(gRPC_DIR "/usr/local/grpc/lib/cmake/grpc" CACHE PATH "" FORCE)
# set(Protobuf_DIR "/usr/local/grpc/lib/cmake/protobuf" CACHE PATH "" FORCE)
