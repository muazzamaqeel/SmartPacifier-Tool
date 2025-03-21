#include <iostream>
#include <thread>
#include <chrono>
#include <atomic>
#include <memory>
#include <grpcpp/grpcpp.h>

#include "communication_layer/broker/DataRetrieval.h"
#include "communication_layer/broker/GlobalMessageQueue.h"
#include "communication_layer/broker/Logger.h"
#include "ipc_layer/grpc/gprc_server.h"

std::atomic<bool> running(true);

void runMqttClient(std::shared_ptr<DataRetrieval> dataRetrieval) {
    Logger::getInstance().log("🚀 Starting MQTT...");
    try {
        dataRetrieval->start();
        while (running) {
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
        dataRetrieval->stop();
        Logger::getInstance().log("🛑 MQTT stopped.");
    } catch (const std::exception &e) {
        Logger::getInstance().log("🔥 MQTT Client Exception: " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("🔥 Unknown MQTT Client Error!");
    }
}

void runGrpcServer() {
    Logger::getInstance().log("✅ gRPC Service initialized.");

    std::string serverAddress("0.0.0.0:50051");
    GrpcService service(globalQueue, globalMutex, globalCV);

    grpc::ServerBuilder builder;
    builder.AddListeningPort(serverAddress, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    std::unique_ptr<grpc::ServerCompletionQueue> cq = builder.AddCompletionQueue();
    std::unique_ptr<grpc::Server> server(builder.BuildAndStart());

    Logger::getInstance().log("✅ gRPC Server started on " + serverAddress);
    std::cout << "🔴 Press ENTER to shutdown..." << std::endl;

    // ✅ Run gRPC Completion Queue Polling in a Separate Thread
    std::thread grpcPollingThread([&]() {
        Logger::getInstance().log("📡 gRPC Completion Queue Polling Started...");
        void* tag;
        bool ok;
        while (running) {
            if (cq->Next(&tag, &ok)) {
                if (!ok) break;  // Stop when queue is shutting down
            }
        }
        Logger::getInstance().log("🛑 gRPC Completion Queue stopped.");
    });

    try {
        server->Wait();
    } catch (const std::exception &e) {
        Logger::getInstance().log("🔥 gRPC Server Exception: " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("🔥 Unknown gRPC Server Error!");
    }

    // ✅ Stop gRPC Completion Queue
    running = false;
    cq->Shutdown();
    grpcPollingThread.join();
}

int main() {
    try {
#ifdef _WIN32
        Logger::getInstance().log("🏁 Running on Windows");
#elif defined(__linux__)
        Logger::getInstance().log("🏁 Running on Linux");
#else
        Logger::getInstance().log("🏁 Running on Unknown OS");
#endif

        Logger::getInstance().log("🛠 Backend is starting...");

        auto dataRetrieval = std::make_shared<DataRetrieval>(
            "tcp://localhost:1883", "DataRetrievalClient", "Pacifier/#"
        );

        std::thread mqttThread(runMqttClient, dataRetrieval);
        std::thread grpcThread(runGrpcServer);

        // ✅ Add Safe Shutdown Mechanism
        std::cin.get();
        Logger::getInstance().log("🛑 Shutting down...");
        running = false;

        mqttThread.join();
        grpcThread.join();

        Logger::getInstance().log("✅ Shutdown complete. Goodbye!");

    } catch (const std::exception &e) {
        Logger::getInstance().log("🔥 CRITICAL ERROR in main(): " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("🔥 CRITICAL UNKNOWN ERROR in main()!");
    }

    std::cout << "\n🛑 Program terminated. Press ENTER to exit...\n";
    std::cin.get();
    return 0;
}
