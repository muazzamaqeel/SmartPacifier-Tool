#pragma once

class PlatformManager {
public:
    PlatformManager() = default;
    virtual ~PlatformManager() = default;

    PlatformManager(const PlatformManager&) = delete;
    PlatformManager& operator=(const PlatformManager&) = delete;
    PlatformManager(PlatformManager&&) noexcept = delete;
    PlatformManager& operator=(PlatformManager&&) noexcept = delete;

    virtual void runBackend() = 0;
};
