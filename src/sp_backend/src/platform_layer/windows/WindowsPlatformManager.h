#ifndef WINDOWSPLATFORMMANAGER_H
#define WINDOWSPLATFORMMANAGER_H

#pragma once
#include "../PlatformManager.h"

class WindowsPlatformManager : public PlatformManager {
public:
    void runBackend() override;
};



#endif //WINDOWSPLATFORMMANAGER_H
