#pragma once

#include <memory>
#include <PlatformManager.h>

#if defined(_WIN32)
#include <windows/WindowsPlatformManager.h>
#elif defined(__linux__)
#include "linux/LinuxPlatformManager.h"
#else
  #error "Unsupported platform: no PlatformManager available"
#endif

inline std::unique_ptr<PlatformManager> createPlatformManager() {
#if defined(_WIN32)
    return std::make_unique<WindowsPlatformManager>();
#elif defined(__linux__)
    return std::make_unique<LinuxPlatformManager>();
#endif
}
