#ifndef LINUXPLATFORMMANAGER_H
#define LINUXPLATFORMMANAGER_H

#pragma once
#include "../PlatformManager.h"

class LinuxPlatformManager : public PlatformManager {
public:
    void runBackend() override;
};

#endif // LINUXPLATFORMMANAGER_H
