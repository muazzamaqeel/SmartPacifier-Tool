//
// Created by Muazzam on 06/04/2025.
//

#pragma once

#include "I_CommunicationLayer.h"
#include <atomic>
#include <thread>
#include <memory>
#include "broker/DataRetrieval.h"

class CommunicationLayer : public I_CommunicationLayer {
public:
    CommunicationLayer()
      : running_(false)
      , dataRetrieval_(std::make_shared<DataRetrieval>(
            "tcp://localhost:1883",
            "DataRetrievalClient",
            "Pacifier/#"))
    {}

    ~CommunicationLayer();

    void startCommunicationServices() override;
    void stopCommunicationServices() override;

private:
    void runMqttClient();
    void runGrpcServer();

    std::atomic<bool> running_;
    std::shared_ptr<DataRetrieval> dataRetrieval_;
    std::thread mqttThread_;
    std::thread grpcThread_;
};
