#include "gprc_server.h"
#include "myservice.pb.h"
#include <broker/Logger.h>

grpc::Status GrpcService::StreamMessages(
    grpc::ServerContext*,
    const google::protobuf::Empty*,
    grpc::ServerWriter<myservice::PayloadMessage>* writer
) {
    try {
        while (true) {
            std::unique_lock<std::mutex> lock(m_queueMutex);
            m_queueCV.wait(lock, [this] { return !m_messageQueue.empty(); });

            std::string rawPayload = std::move(m_messageQueue.front());
            m_messageQueue.pop();
            lock.unlock();

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
        Logger::getInstance().log(
            std::string("gRPC ERROR in StreamMessages(): ") + e.what());
        return grpc::Status(grpc::StatusCode::UNKNOWN, "Internal server error");
    }
}
