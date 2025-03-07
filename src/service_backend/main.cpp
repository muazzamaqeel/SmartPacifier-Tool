#include <iostream>
#include <filesystem>
#include <thread>
#include "src/external_libs/vcpkg/downloads/tools/perl/5.40.0.1/c/x86_64-w64-mingw32/include/wrl/client.h"
#include "src/broker/brokercheck_os.h"
#include "src/broker/mqtt_subscriber.h"

int main() {
    std::cout << "Current Working Directory: "
              << std::filesystem::current_path() << std::endl;

    // Broker Check
    BrokerCheckOS brokerCheck;
    brokerCheck.checkAndStartBroker();

    // MQTT Subscriber
    MQTTSubscriber subscriber("tcp://localhost:1883", "service_backend_" + std::to_string(std::rand()), "Pacifier/#");
    subscriber.start();

    // Keep the application running
    std::cout << "Waiting for messages..." << std::endl;
    while (true) {
        std::this_thread::sleep_for(std::chrono::seconds(5));
    }

    return 0;
}
