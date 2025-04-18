#include "CommunicationLayer.h"
#include <thread>
#include <chrono>
#include <grpcpp/grpcpp.h>
#include <broker/Logger.h>
#include <broker/GlobalMessageQueue.h>
#include <broker/BrokerCheck.h>
#include <broker/DataRetrieval.h>
#include <ipc_layer/grpc/gprc_server.h>

CommunicationLayer::CommunicationLayer()
  : running_(false)
  , dataRetrieval_(std::make_shared<DataRetrieval>(
        "tcp://localhost:1883",
        "DataRetrievalClient",
        "Pacifier/#"))
{}

CommunicationLayer::~CommunicationLayer() {
    stopCommunicationServices();
    if (mqttThread_.joinable()) mqttThread_.join();
    if (grpcThread_.joinable()) grpcThread_.join();
}

void CommunicationLayer::startCommunicationServices() {
    if (!BrokerCheck::isMosquittoRunning()) {
        Logger::getInstance().log("Please start Mosquitto broker first.");
        return;
    }
    Logger::getInstance().log("Mosquitto running.");

    running_ = true;
    dataRetrieval_->setMessageCallback([](const std::string &msg) {
        std::lock_guard lock(broker::global_queue_mutex);
        broker::globalQueue.push(msg);
        broker::cv_global_queue.notify_all();
    });

    mqttThread_ = std::thread(&CommunicationLayer::runMqttClient, this);
    grpcThread_ = std::thread(&CommunicationLayer::runGrpcServer, this);
}

void CommunicationLayer::stopCommunicationServices() {
    running_ = false;
    dataRetrieval_->stop();
}

void CommunicationLayer::runMqttClient() const {
    Logger::getInstance().log("Starting MQTT...");
    try {
        dataRetrieval_->start();
        Logger::getInstance().log("MQTT stopped.");
    } catch (const std::exception &e) {
        Logger::getInstance().log("MQTT exception: " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("Unknown MQTT error.");
    }
}

void CommunicationLayer::runGrpcServer() {
    Logger::getInstance().log("Initializing gRPC...");
    const std::string addr("0.0.0.0:50051");
    GrpcService service(broker::globalQueue, broker::global_queue_mutex, broker::cv_global_queue);

    grpc::ServerBuilder builder;
    builder.AddListeningPort(addr, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    // Build server and completion queue locally
    auto cq = builder.AddCompletionQueue();
    auto server = builder.BuildAndStart();
    Logger::getInstance().log("gRPC server listening on " + addr);

    // Shutdown watcher: triggers server shutdown when running_ becomes false
    std::thread shutdownWatcher([&]() {
        while (running_) {
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
        server->Shutdown();
        cq->Shutdown();
    });

    // Block until server shutdown
    try {
        server->Wait();
    } catch (const std::exception &e) {
        Logger::getInstance().log("gRPC exception: " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("Unknown gRPC error.");
    }

    if (shutdownWatcher.joinable()) shutdownWatcher.join();
    Logger::getInstance().log("gRPC server stopped.");
}
