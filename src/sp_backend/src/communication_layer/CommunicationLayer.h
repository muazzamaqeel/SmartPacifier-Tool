// File: src/communication_layer/CommunicationLayer.h
#pragma once

#include "I_CommunicationLayer.h"
#include <atomic>
#include <thread>
#include <memory>

// Your DataRetrieval lives in the global namespace
#include <broker/DataRetrieval.h>

#include "ipc_layer/grpc/grpc_client.h"

class CommunicationLayer : public I_CommunicationLayer {
public:
    CommunicationLayer();
    ~CommunicationLayer() override;

    CommunicationLayer(const CommunicationLayer&) = delete;
    CommunicationLayer& operator=(const CommunicationLayer&) = delete;

    void startCommunicationServices() override;
    void stopCommunicationServices() override;

private:
    void runMqttClient();

    std::atomic<bool>                running_;
    std::shared_ptr<DataRetrieval>   dataRetrieval_;  // <-- global namespace!
    MyGrpcClient                     grpcClient_;
    std::thread                      mqttThread_;
};
