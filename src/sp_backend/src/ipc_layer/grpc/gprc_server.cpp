#include "gprc_server.h"
#include "myservice.pb.h"
#include "myservice.grpc.pb.h"
#include <broker/Logger.h>

// Constructor: initialize the global queue, mutex, and condition variable references.
GrpcService::GrpcService(std::queue<std::string>& queue,
                         std::mutex& mutex,
                         std::condition_variable& cv)
    : m_messageQueue(queue)
    , m_queueMutex(mutex)
    , m_queueCV(cv)
{}

/**
 * Implementation of the StreamMessages RPC.
 * The server waits for new MQTT messages to arrive in the global queue.
 * For each message, it deserializes the raw payload into a Protos::SensorData,
 * wraps it in a PayloadMessage, and writes it to the gRPC stream.
 */
grpc::Status GrpcService::StreamMessages(
    grpc::ServerContext* /*context*/,
    const google::protobuf::Empty* /*request*/,
    grpc::ServerWriter<myservice::PayloadMessage>* writer
) {
    try {
        while (true) {
            std::unique_lock<std::mutex> lock(m_queueMutex);
            m_queueCV.wait(lock, [this] { return !m_messageQueue.empty(); });

            // Retrieve the raw serialized SensorData payload from the queue.
            std::string rawPayload = m_messageQueue.front();
            m_messageQueue.pop();
            lock.unlock();

            // Deserialize the raw payload into a SensorData object.
            Protos::SensorData sensorData;
            if (!sensorData.ParseFromString(rawPayload)) {
                Logger::getInstance().log("Failed to parse SensorData in gRPC server");
                continue;
            }

            // Wrap the deserialized SensorData into a PayloadMessage.
            myservice::PayloadMessage payload;
            *payload.mutable_sensor_data() = sensorData;

            // Write the PayloadMessage to the gRPC stream.
            writer->Write(payload);
        }
    } catch (const std::exception& e) {
        Logger::getInstance().log(std::string("gRPC ERROR in StreamMessages(): ") + e.what());
        return grpc::Status(grpc::StatusCode::UNKNOWN, "Internal server error");
    }
    return grpc::Status::OK;
}
