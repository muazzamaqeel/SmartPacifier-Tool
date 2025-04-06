#ifndef PLATFORMFACTORY_H
#define PLATFORMFACTORY_H
#pragma once

#include <memory>
#include "PlatformManager.h"

#ifdef _WIN32
#include "windows/WindowsPlatformManager.h"
#elif defined(__linux__)
#include "linux/LinuxPlatformManager.h"
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

#endif // PLATFORMFACTORY_H
