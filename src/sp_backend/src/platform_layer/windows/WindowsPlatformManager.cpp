#include "WindowsPlatformManager.h"
#include "../../communication_layer/broker/Logger.h"
#include "../../communication_layer/I_CommunicationLayer.h"
#include "../../communication_layer/CommunicationLayer.h"
#include <iostream>
#include <thread>

void WindowsPlatformManager::runBackend() {
    std::cout << "Running on Windows" << std::endl;
    // Create an instance of the communication layer implementation.
    CommunicationLayer commLayer;
    commLayer.startCommunicationServices();

    std::cin.get(); // wait for shutdown trigger
    std::cout << "Shutting down..." << std::endl;
    commLayer.stopCommunicationServices();

    std::cout << "Shutdown complete. Goodbye!" << std::endl;
    std::cout << "\nProgram terminated. Press ENTER to exit...\n";
    std::cin.get();
}
