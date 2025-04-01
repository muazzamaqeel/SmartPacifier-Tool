//
// Created by Muazzam on 01/04/2025.
//

#ifndef LINUXPLATFORMMANAGER_H
#define LINUXPLATFORMMANAGER_H
#pragma once
#include "../PlatformManager.h"



class LinuxPlatformManager : public PlatformManager {
public:
    void runBackend() override;
};


#endif //LINUXPLATFORMMANAGER_H
