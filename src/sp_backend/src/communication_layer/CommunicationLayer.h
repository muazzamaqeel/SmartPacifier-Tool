//
// Created by Muazzam on 06/04/2025.
//

#pragma once

#include <I_CommunicationLayer.h>
#include <atomic>
#include <thread>
#include <memory>

#include <broker/DataRetrieval.h>
#include <ipc_layer/grpc/gprc_server.h>

class CommunicationLayer : public I_CommunicationLayer {
public:
    CommunicationLayer();
    ~CommunicationLayer() override;

    CommunicationLayer(const CommunicationLayer&) = delete;
    CommunicationLayer& operator=(const CommunicationLayer&) = delete;
    CommunicationLayer(CommunicationLayer&&) = delete;
    CommunicationLayer& operator=(CommunicationLayer&&) = delete;

    void startCommunicationServices() override;
    void stopCommunicationServices() override;

private:
    void runMqttClient() const;
    void runGrpcServer() const;

    std::atomic<bool>                running_;
    std::shared_ptr<DataRetrieval>   dataRetrieval_;
    // updates: owns the service instance
    std::unique_ptr<GrpcService>     grpcService_;   
    std::thread                      mqttThread_;
    std::thread                      grpcThread_;
};
