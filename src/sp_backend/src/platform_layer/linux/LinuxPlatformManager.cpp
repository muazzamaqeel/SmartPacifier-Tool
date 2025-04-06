#include "LinuxPlatformManager.h"
#include "../../communication_layer/broker/Logger.h"
#include "../../communication_layer/CommunicationLayer.h"
#include <iostream>
#include <thread>

void LinuxPlatformManager::runBackend() {
    std::cout << "Running on Linux" << std::endl;
    // Create an instance of the shared communication layer.
    CommunicationLayer commLayer;
    commLayer.startCommunicationServices();

    // Wait for user input to trigger shutdown.
    std::cin.get();
    std::cout << "Shutting down..." << std::endl;
    commLayer.stopCommunicationServices();

    std::cout << "Shutdown complete. Goodbye!" << std::endl;
    std::cout << "\nProgram terminated. Press ENTER to exit...\n";
    std::cin.get();
}
