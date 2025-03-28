#include <iostream>
#include <thread>
#include <chrono>
#include <atomic>
#include <memory>
#include <grpcpp/grpcpp.h>

// Project includes
#include "communication_layer/broker/DataRetrieval.h"
#include "communication_layer/broker/GlobalMessageQueue.h"
#include "communication_layer/broker/Logger.h"
#include "ipc_layer/grpc/gprc_server.h"

// Include the generated Protobuf for SensorData
#include "ipc_layer/grpc/sensor_data.pb.h"

std::atomic<bool> running(true);

/**
 * Callback for incoming MQTT messages.
 * This callback simply pushes the raw MQTT payload (serialized Protos::SensorData)
 * into the global message queue for the gRPC server.
 */
void handleIncomingMqttMessage(const std::string &rawPayload) {
    {
        std::lock_guard<std::mutex> lock(globalMutex);
        globalQueue.push(rawPayload);
    }
    globalCV.notify_one();
}

/**
 * Runs the MQTT client, registers the callback, and waits until shutdown.
 */
void runMqttClient(std::shared_ptr<DataRetrieval> dataRetrieval) {
    Logger::getInstance().log("🚀 Starting MQTT...");
    try {
        // Register the callback that pushes raw payloads into the queue
        dataRetrieval->setMessageCallback(handleIncomingMqttMessage);
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

/**
 * Runs the gRPC server that streams PayloadMessage objects to the client.
 * It retrieves raw MQTT payloads from the global queue, deserializes them into
 * a Protos::SensorData, wraps that in a PayloadMessage, and writes it to the stream.
 */
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

    // Run gRPC Completion Queue polling in a separate thread
    std::thread grpcPollingThread([&]() {
        Logger::getInstance().log("📡 gRPC Completion Queue Polling Started...");
        void* tag;
        bool ok;
        while (running) {
            if (cq->Next(&tag, &ok)) {
                if (!ok) break;
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

        // Wait for user input to shutdown
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
