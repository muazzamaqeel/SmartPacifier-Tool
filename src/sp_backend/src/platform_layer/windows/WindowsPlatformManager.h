#pragma once
#include "../PlatformManager.h"

class WindowsPlatformManager : public PlatformManager {
public:
    void runBackend() override;
};

