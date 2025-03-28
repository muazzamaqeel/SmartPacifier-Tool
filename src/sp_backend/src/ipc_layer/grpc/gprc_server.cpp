#include "gprc_server.h"
#include <grpcpp/impl/codegen/sync_stream.h>
#include "../../communication_layer/broker/Logger.h"

GrpcService::GrpcService(std::queue<std::string>& queue, std::mutex& mutex, std::condition_variable& cv)
    // Call the base constructor for the generated service class.
    : myservice::MyService::Service(), messageQueue(queue), queueMutex(mutex), queueCV(cv) {}

grpc::Status GrpcService::StreamMessages(
    grpc::ServerContext* context,
    const google::protobuf::Empty* /*request*/,
    grpc::ServerWriter<google::protobuf::StringValue>* writer) {
    try {
        while (true) {
            std::unique_lock<std::mutex> lock(queueMutex);
            // Wait until there is data in the message queue.
            queueCV.wait(lock, [this] { return !messageQueue.empty(); });

            std::string message = messageQueue.front();
            messageQueue.pop();
            lock.unlock();

            google::protobuf::StringValue pbMessage;
            pbMessage.set_value(message);
            writer->Write(pbMessage);
        }
    } catch (const std::exception &e) {
        Logger::getInstance().log("🔥 gRPC ERROR in StreamMessages(): " + std::string(e.what()));
        return grpc::Status(grpc::StatusCode::UNKNOWN, "Internal server error");
    }
    return grpc::Status::OK;
}
