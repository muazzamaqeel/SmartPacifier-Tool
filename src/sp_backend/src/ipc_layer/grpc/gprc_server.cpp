#include "gprc_server.h"
#include <iostream>
#include <grpcpp/impl/codegen/sync_stream.h>

GrpcService::GrpcService(std::queue<std::string>& queue, std::mutex& mutex, std::condition_variable& cv)
    : grpc::Service(), messageQueue(queue), queueMutex(mutex), queueCV(cv) {}

grpc::Status GrpcService::StreamMessages(
    grpc::ServerContext* context,
    grpc::ServerWriter<google::protobuf::StringValue>* writer) {

    while (true) {
        std::unique_lock<std::mutex> lock(queueMutex);
        queueCV.wait(lock, [this] { return !messageQueue.empty(); });

        if (messageQueue.empty())  // 🚀 Safety check
            continue;

        std::string message = messageQueue.front();
        messageQueue.pop();
        lock.unlock();  // 🚀 Unlock before writing to avoid deadlock

        google::protobuf::StringValue pbMessage;
        pbMessage.set_value(message);
        writer->Write(pbMessage);
    }
    return grpc::Status::OK;
}

