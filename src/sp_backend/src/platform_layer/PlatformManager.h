#pragma once

#include <broker/Logger.h>
#include <communication_layer/CommunicationLayer.h>
#include <iostream>

class PlatformManager {
public:
    PlatformManager() = default;
    virtual ~PlatformManager() = default;

    PlatformManager(const PlatformManager&) = delete;
    PlatformManager& operator=(const PlatformManager&) = delete;
    PlatformManager(PlatformManager&&) noexcept = delete;
    PlatformManager& operator=(PlatformManager&&) noexcept = delete;

    // Default implementation for both Windows and Linux:
    virtual void runBackend() {
#ifndef NDEBUG
        std::cout << "Running on platform" << std::endl;
#endif
        CommunicationLayer commLayer;
        commLayer.startCommunicationServices();

#ifndef NDEBUG
        std::cin.get();
        std::cout << "Shutting down..." << std::endl;
        commLayer.stopCommunicationServices();
        std::cout << "Shutdown complete. Goodbye!" << std::endl;
        std::cout << "\nProgram terminated. Press ENTER to exit...\n";
        std::cin.get();
#endif
    }
};
