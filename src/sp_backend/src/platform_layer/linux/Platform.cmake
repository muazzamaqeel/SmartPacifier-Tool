# Linux Platform configuration
message(STATUS "Configuring for Linux platform")
# Adding extra compile warnings for Linux.
add_compile_options(-Wall -Wextra -Wpedantic)

# Potential Location of the Installed Libraries - (Will be updated on GitHub, as we are still required to Update the Building Process of the Libraries on the Linux Machine)

# set(CMAKE_PREFIX_PATH "/usr/local/grpc" CACHE PATH "" FORCE)
# set(gRPC_DIR "/usr/local/grpc/lib/cmake/grpc" CACHE PATH "" FORCE)
# set(Protobuf_DIR "/usr/local/grpc/lib/cmake/protobuf" CACHE PATH "" FORCE)
