#ifndef GRPC_SERVER_H
#define GRPC_SERVER_H

#include <grpcpp/grpcpp.h>
#include <grpcpp/server.h>
#include <grpcpp/server_builder.h>
#include <grpcpp/server_context.h>
#include <grpcpp/support/async_stream.h>  // Fix for incomplete type
#include <google/protobuf/wrappers.pb.h>
#include "myservice.grpc.pb.h"  // Generated from your .proto
#include <queue>
#include <mutex>
#include <condition_variable>

// Inherit from the generated service class (using your proto package "myservice")
class GrpcService final : public myservice::MyService::Service {
public:
    GrpcService(std::queue<std::string>& queue, std::mutex& mutex, std::condition_variable& cv);

    // Updated signature: Added the missing 'const google::protobuf::Empty* request' parameter.
    grpc::Status StreamMessages(
        grpc::ServerContext* context,
        const google::protobuf::Empty* request,
        grpc::ServerWriter<google::protobuf::StringValue>* writer
    ) override;

private:
    std::queue<std::string>& messageQueue;
    std::mutex& queueMutex;
    std::condition_variable& queueCV;
};

#endif // GRPC_SERVER_H
