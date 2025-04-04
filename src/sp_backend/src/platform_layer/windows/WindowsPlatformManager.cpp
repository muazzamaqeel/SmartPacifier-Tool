#include "WindowsPlatformManager.h"
#include "../../communication_layer/broker/Logger.h"
#include "../../communication_layer/broker/DataRetrieval.h"
#include "../../communication_layer/broker/GlobalMessageQueue.h"
#include "../../ipc_layer/grpc/gprc_server.h"
#include "../../communication_layer/broker/BrokerCheck.h"
#include <thread>
#include <chrono>
#include <atomic>
#include <iostream>

static std::atomic<bool> running(true);

void handleIncomingMqttMessage(const std::string &rawPayload) {
    {
        std::lock_guard<std::mutex> lock(globalMutex);
        globalQueue.push(rawPayload);
    }
    globalCV.notify_one();
}

void runMqttClient(const std::shared_ptr<DataRetrieval> &dataRetrieval) {
    Logger::getInstance().log("Starting MQTT... ");
    try {
        dataRetrieval->setMessageCallback(handleIncomingMqttMessage);
        dataRetrieval->start();
        while (running) {
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
        dataRetrieval->stop();
        Logger::getInstance().log("MQTT stopped");
    } catch (const std::exception &e) {
        Logger::getInstance().log("MQTT Client Exception : " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("Unknown MQTT Client Error!");
    }
}

void runGrpcServer() {
    Logger::getInstance().log("gRPC Service initialized.");
    std::string serverAddress("0.0.0.0:50051");
    GrpcService service(globalQueue, globalMutex, globalCV);

    grpc::ServerBuilder builder;
    builder.AddListeningPort(serverAddress, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    std::unique_ptr<grpc::ServerCompletionQueue> cq = builder.AddCompletionQueue();
    std::unique_ptr<grpc::Server> server(builder.BuildAndStart());

    Logger::getInstance().log("gRPC Server started on " + serverAddress);
    std::cout << "Mosquitto running: "
              << (BrokerCheck::isMosquittoRunning() ? "Yes" : "No") << std::endl;
    std::cout << "Press ENTER to shutdown..." << std::endl;

    std::thread grpcPollingThread([&]() {
        Logger::getInstance().log("📡 gRPC Completion Queue Polling Started...");
        void* tag;
        bool ok;
        while (running) {
            if (cq->Next(&tag, &ok)) {
                if (!ok) break;
            }
        }
        Logger::getInstance().log("gRPC Completion Queue stopped.");
    });

    try {
        server->Wait();
    } catch (const std::exception &e) {
        Logger::getInstance().log("gRPC Server Exception: " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("Unknown gRPC Server Error!");
    }

    running = false;
    cq->Shutdown();
    grpcPollingThread.join();
}

void WindowsPlatformManager::runBackend() {
    std::cout << "Running on Windows" << std::endl;
    std::cout << "Checking if Mosquitto broker is running..." << std::endl;
    if (!BrokerCheck::isMosquittoRunning()) {
        std::cout << "Mosquitto is not running. Please start the Mosquitto broker first." << std::endl;
        return;
    } else {
        std::cout << "Mosquitto is running." << std::endl;
    }

    auto dataRetrieval = std::make_shared<DataRetrieval>(
        "tcp://localhost:1883", "DataRetrievalClient", "Pacifier/#"
    );

    std::thread mqttThread(runMqttClient, dataRetrieval);
    std::thread grpcThread(runGrpcServer);

    std::cin.get(); // wait for shutdown
    std::cout << "Shutting down..." << std::endl;
    running = false;

    mqttThread.join();
    grpcThread.join();

    std::cout << "Shutdown complete. Goodbye!" << std::endl;
    std::cout << "\nProgram terminated. Press ENTER to exit...\n";
    std::cin.get();
}
