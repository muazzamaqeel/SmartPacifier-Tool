#pragma once

#include "I_CommunicationLayer.h"
#include <atomic>
#include <thread>
#include <memory>

#include <broker/DataRetrieval.h>           // MQTT wrapper
#include "ipc_layer/grpc/grpc_client.h"     // MyGrpcClient

class CommunicationLayer : public I_CommunicationLayer {
public:
    CommunicationLayer();
    ~CommunicationLayer() override;

    CommunicationLayer(const CommunicationLayer&) = delete;
    CommunicationLayer& operator=(const CommunicationLayer&) = delete;

    void startCommunicationServices() override;
    void stopCommunicationServices() override;

private:
    void runMqttClient() const;

    std::atomic<bool>                running_;
    std::shared_ptr<DataRetrieval>   dataRetrieval_;
    MyGrpcClient                     grpcClient_;
    std::thread                      mqttThread_;
};
