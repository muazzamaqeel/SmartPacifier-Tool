#pragma once

#include <PlatformManager.h>

class LinuxPlatformManager : public PlatformManager {
public:
    void runBackend() override;
};
