#include "gprc_server.h"
#include "myservice.pb.h"    // for Protos::SensorData
#include <broker/Logger.h>

grpc::Status GrpcService::StreamMessages(
    grpc::ServerContext* /*context*/,
    const google::protobuf::Empty* /*request*/,
    grpc::ServerWriter<myservice::PayloadMessage>* writer
) {
    try {
        while (true) {
            // Wait for the batch callback to enqueue items
            std::unique_lock<std::mutex> lk(m_outMutex);
            m_outCV.wait(lk, [&]{ return !m_outQueue.empty(); });

            auto rawPayload = std::move(m_outQueue.front());
            m_outQueue.pop();
            lk.unlock();

            Protos::SensorData sensorData;
            if (!sensorData.ParseFromString(rawPayload)) {
                Logger::getInstance().log("Failed to parse SensorData in gRPC server");
                continue;
            }

            myservice::PayloadMessage payload;
            *payload.mutable_sensor_data() = std::move(sensorData);
            writer->Write(payload);
        }
    } catch (const std::exception& e) {
        Logger::getInstance().log("gRPC ERROR in StreamMessages(): " + std::string(e.what()));
        return grpc::Status(grpc::StatusCode::UNKNOWN, "Internal server error");
    }
}
