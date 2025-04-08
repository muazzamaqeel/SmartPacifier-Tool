#include "CommunicationLayer.h"
#include "broker/Logger.h"
#include "broker/GlobalMessageQueue.h"
#include "broker/BrokerCheck.h"
#include "../ipc_layer/grpc/gprc_server.h"
#include <chrono>
#include <thread>
#include <iostream>
#include <grpcpp/grpcpp.h>

#include "broker/DataRetrieval.h"

CommunicationLayer::CommunicationLayer() : running_(false) {
    // Initialize the MQTT client.
    dataRetrieval_ = std::make_shared<DataRetrieval>("tcp://localhost:1883", "DataRetrievalClient", "Pacifier/#");
}

CommunicationLayer::~CommunicationLayer() {
    stopCommunicationServices();
    if (mqttThread_.joinable())
        mqttThread_.join();
    if (grpcThread_.joinable())
        grpcThread_.join();
}

void CommunicationLayer::startCommunicationServices() {
    if (!BrokerCheck::isMosquittoRunning()){
         std::cout << "Mosquitto is not running. Please start the Mosquitto broker first." << std::endl;
         return;
    } else {
         std::cout << "Mosquitto is running." << std::endl;
    }

    running_ = true;

    // Set the MQTT message callback to push messages into the global queue.
    dataRetrieval_->setMessageCallback([](const std::string &payload) {
         {
             std::lock_guard<std::mutex> lock(globalMutex);
             globalQueue.push(payload);
         }
         globalCV.notify_one();
    });

    // Launch the MQTT and gRPC threads.
    mqttThread_ = std::thread(&CommunicationLayer::runMqttClient, this);
    grpcThread_ = std::thread(&CommunicationLayer::runGrpcServer, this);
}

void CommunicationLayer::stopCommunicationServices() {
    running_ = false;
    dataRetrieval_->stop();
}

void CommunicationLayer::runMqttClient() {
    Logger::getInstance().log("Starting MQTT...");
    try {
         dataRetrieval_->start();
         while (running_) {
              std::this_thread::sleep_for(std::chrono::seconds(1));
         }
         dataRetrieval_->stop();
         Logger::getInstance().log("MQTT stopped");
    } catch (const std::exception &e) {
         Logger::getInstance().log("MQTT Client Exception: " + std::string(e.what()));
    } catch (...) {
         Logger::getInstance().log("Unknown MQTT Client Error!");
    }
}

void CommunicationLayer::runGrpcServer() {
    Logger::getInstance().log("gRPC Service initialized.");
    std::string serverAddress("0.0.0.0:50051");
    // Instantiate GrpcService (defined in ipc_layer/grpc/gprc_server.h)
    GrpcService service(globalQueue, globalMutex, globalCV);

    grpc::ServerBuilder builder;
    builder.AddListeningPort(serverAddress, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    std::unique_ptr<grpc::ServerCompletionQueue> cq = builder.AddCompletionQueue();
    std::unique_ptr<grpc::Server> server(builder.BuildAndStart());

    Logger::getInstance().log("gRPC Server started on " + serverAddress);
    std::cout << "Press ENTER to shutdown..." << std::endl;

    std::thread grpcPollingThread([&]() {
         Logger::getInstance().log("gRPC Completion Queue Polling Started...");
         void* tag;
         bool ok;
         while (running_ && cq->Next(&tag, &ok)) {
             if (!ok)
                 break;
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
    running_ = false;
    cq->Shutdown();
    grpcPollingThread.join();
}
