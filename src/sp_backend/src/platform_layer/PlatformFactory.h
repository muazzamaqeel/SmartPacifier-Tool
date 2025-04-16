#pragma once

#include <memory>
#include "PlatformManager.h"

#ifdef _WIN32
#include "windows/WindowsPlatformManager.h"
#elif defined(__linux__)
#include "linux/LinuxPlatformManager.h"
#elif
#error "missing platform manager for current platform"
#endif

inline std::unique_ptr<PlatformManager> createPlatformManager() {
#ifdef _WIN32
    return std::make_unique<WindowsPlatformManager>();
#elif defined(__linux__)
    return std::make_unique<LinuxPlatformManager>();
#else
    return nullptr;
#endif
}

