#pragma once

class PlatformManager {
public:
    virtual ~PlatformManager() = default;
    virtual void runBackend() = 0;
};

