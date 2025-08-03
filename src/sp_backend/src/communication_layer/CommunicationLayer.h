#pragma once

#include "I_CommunicationLayer.h"
#include <atomic>
#include <thread>
#include <memory>
#include <string>

#include <broker/DataRetrieval.h>
#include "ipc_layer/grpc/grpc_client.h"
#include "data_processing/RawData.h"
#include "data_processing/DeserializedData.h"

class CommunicationLayer final : public I_CommunicationLayer {
public:
    enum class Mode {
        ForwardRaw,        // just verify & push the raw bytes
        ParseAndFlatten    // fully deserialize, flatten, then push
    };

    explicit CommunicationLayer(Mode mode = Mode::ParseAndFlatten);
    ~CommunicationLayer() override;

    CommunicationLayer(const CommunicationLayer&) = delete;
    CommunicationLayer& operator=(const CommunicationLayer&) = delete;

    void startCommunicationServices() override;
    void stopCommunicationServices() override;

private:
    void runMqttClient() const;

    std::atomic<bool>              running_;
    Mode                           mode_;
    std::shared_ptr<DataRetrieval> dataRetrieval_;
    MyGrpcClient                   grpcClient_;
    std::thread                    mqttThread_;

    std::string                    flattenedFilePath_;
    RawData                        rawData_;
    DeserializedData               deserializedData_;
};
