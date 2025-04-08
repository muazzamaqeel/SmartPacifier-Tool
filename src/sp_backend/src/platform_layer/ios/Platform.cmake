# iOS Platform configuration
message(STATUS "Configuring for iOS platform")

# Set the sysroot to the iPhoneOS SDK.
set(CMAKE_OSX_SYSROOT iphoneos)

# Set the minimum deployment target.
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.0")
