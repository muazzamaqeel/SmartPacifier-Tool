#include "communication_layer/CommunicationLayer.h"

#include <communication_layer/debug/Logger.h>
#include <broker/BrokerCheck.h>
#include <broker/GlobalMessageQueue.h>

#ifdef GetMessage
# undef GetMessage
#endif

#include <sensor_data.pb.h>
#include <filesystem>
#include <fstream>

namespace fs = std::filesystem;

CommunicationLayer::CommunicationLayer(Mode mode)
  : running_(false),
    mode_(mode),
    flattenedFilePath_("flattened_messages.txt"),
    rawData_(flattenedFilePath_),
    deserializedData_(flattenedFilePath_),
    dataRetrieval_(std::make_shared<DataRetrieval>(
      "tcp://localhost:1883",
      "DataRetrievalClient",
      "Pacifier/#"))
{
    // create file if missing
    {
        std::ofstream t(flattenedFilePath_, std::ios::app);
        if (!t) {
            Logger::getInstance().log("ERROR: could not create " + flattenedFilePath_);
        }
    }
    Logger::getInstance().log("CWD is: " + fs::current_path().string());
    Logger::getInstance().log("Flattened output will go to: " + flattenedFilePath_);
}

CommunicationLayer::~CommunicationLayer() {
    stopCommunicationServices();
    if (mqttThread_.joinable())
        mqttThread_.join();
}

void CommunicationLayer::startCommunicationServices() {
    if (!BrokerCheck::canConnect("tcp://localhost:1883",
                                 "CommLayerProbeClient", 5))
    {
        Logger::getInstance().log(
          "Cannot reach Mosquitto on localhost:1883 — please start it."
        );
        return;
    }
    Logger::getInstance().log("Mosquitto running.");

    grpcClient_.init("127.0.0.1", 50051);

    // batching setup
    constexpr size_t batchSize = 1;
    broker::globalQueue().setBatchCallback(
      [this](const std::vector<std::string>& batch) {
        for (auto &rawMsg : batch) {
          Protos::SensorData sd;
          if (sd.ParseFromString(rawMsg))
            grpcClient_.send(sd);
          else
            Logger::getInstance().log("invalid batched SensorData");
        }
      },
      batchSize
    );

    // choose callback
    if (mode_ == Mode::ForwardRaw) {
        dataRetrieval_->setMessageCallback(
          [this](const std::string& raw){ rawData_.process(raw); }
        );
    }
    else {
        dataRetrieval_->setMessageCallback(
          [this](const std::string& raw){ deserializedData_.process(raw); }
        );
    }

    running_    = true;
    mqttThread_ = std::thread(&CommunicationLayer::runMqttClient, this);
}

void CommunicationLayer::stopCommunicationServices() {
    running_ = false;
    dataRetrieval_->stop();
}

void CommunicationLayer::runMqttClient() const {
    Logger::getInstance().log("Starting MQTT loop…");
    try {
        dataRetrieval_->start();
        Logger::getInstance().log("MQTT stopped.");
    }
    catch (const std::exception &e) {
        Logger::getInstance().log(std::string("MQTT exception: ")+e.what());
    }
}
