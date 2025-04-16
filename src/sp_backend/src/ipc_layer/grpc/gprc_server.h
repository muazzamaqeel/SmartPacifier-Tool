#pragma once

#include <grpcpp/grpcpp.h>
#include <google/protobuf/empty.pb.h>
#include "myservice.grpc.pb.h"  // Generated from myservice.proto
#include <queue>
#include <mutex>
#include <condition_variable>

class GrpcService final : public myservice::MyService::Service {
public:
    GrpcService(std::queue<std::string>& queue, std::mutex& mutex, std::condition_variable& cv);

    grpc::Status StreamMessages(
        grpc::ServerContext* context,
        const google::protobuf::Empty* request,
        grpc::ServerWriter<myservice::PayloadMessage>* writer
    ) override;

private:
    std::queue<std::string>& m_messageQueue;
    std::mutex& m_queueMutex;
    std::condition_variable& m_queueCV;
};

