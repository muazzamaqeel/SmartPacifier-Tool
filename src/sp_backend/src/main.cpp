#include <iostream>
#include "communication_layer/broker/DataRetrieval.h"
#include <thread>
#include <chrono>

int main() {
    // Detect the operating system.
#ifdef _WIN32
    std::cout << "Running on Windows" << std::endl;
#elif defined(__linux__)
    std::cout << "Running on Linux" << std::endl;
#else
    std::cout << "Running on an unknown OS" << std::endl;
#endif

    // Configure the broker, client ID, and topic.
    std::string broker = "tcp://localhost:1883";
    std::string clientId = "DataRetrievalClient";
    std::string topic = "Pacifier/#";

    // Create the DataRetrieval instance.
    DataRetrieval dataRetrieval(broker, clientId, topic);

    // Start the connection and subscription.
    dataRetrieval.start();

    // Let the client run for a while to receive messages.
    std::this_thread::sleep_for(std::chrono::seconds(60));

    // Stop the connection.
    dataRetrieval.stop();

    return 0;
}
