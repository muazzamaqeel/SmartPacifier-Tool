// File: src/communication_layer/CommunicationLayer.cpp
#include "communication_layer/CommunicationLayer.h"

#include <broker/Logger.h>      // broker::Logger
#include <broker/BrokerCheck.h> // broker::BrokerCheck

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
}

void CommunicationLayer::startCommunicationServices() {
    if (!BrokerCheck::isMosquittoRunning()) {
        Logger::getInstance().log("Please start Mosquitto broker first.");
        return;
    }
    Logger::getInstance().log("Mosquitto running.");

    // 1️⃣ Open the gRPC client‐stream
    grpcClient_.init("127.0.0.1", 50051);

    // 2️⃣ On each incoming MQTT message, parse and send
    dataRetrieval_->setMessageCallback(
      [this](const std::string &raw) {
        Protos::SensorData sd;
        if (!sd.ParseFromString(raw)) {
          Logger::getInstance().log("Failed to parse SensorData");
          return;
        }
        grpcClient_.send(sd);
      }
    );

    // 3️⃣ Launch the MQTT loop on its own thread
    mqttThread_ = std::thread(&CommunicationLayer::runMqttClient, this);
}

void CommunicationLayer::stopCommunicationServices() {
    running_ = false;
    dataRetrieval_->stop();
}

void CommunicationLayer::runMqttClient() {
    Logger::getInstance().log("Starting MQTT...");
    try {
        dataRetrieval_->start();
        Logger::getInstance().log("MQTT stopped.");
    } catch (const std::exception &e) {
        Logger::getInstance().log(
          std::string("MQTT exception: ") + e.what());
    }
}
