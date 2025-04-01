//
// Created by Muazzam on 01/04/2025.
//

#ifndef PLATFORMMANAGER_H
#define PLATFORMMANAGER_H
#pragma once

class PlatformManager {
public:
    virtual ~PlatformManager() = default;
    virtual void runBackend() = 0;
};


#endif //PLATFORMMANAGER_H
