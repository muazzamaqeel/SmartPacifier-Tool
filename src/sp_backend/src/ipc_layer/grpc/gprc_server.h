#ifndef GRPC_SERVER_H
#define GRPC_SERVER_H

#include <grpcpp/grpcpp.h>
#include <grpcpp/server.h>
#include <grpcpp/server_builder.h>
#include <grpcpp/server_context.h>
#include <grpcpp/support/async_stream.h>  // ✅ Fix for incomplete type
#include <google/protobuf/wrappers.pb.h>
#include <queue>
#include <mutex>
#include <condition_variable>

class GrpcService final : public grpc::Service {
public:
    GrpcService(std::queue<std::string>& queue, std::mutex& mutex, std::condition_variable& cv);

    grpc::Status StreamMessages(
        grpc::ServerContext* context,
        grpc::ServerWriter<google::protobuf::StringValue>* writer
    );

private:
    std::queue<std::string>& messageQueue;
    std::mutex& queueMutex;
    std::condition_variable& queueCV;
};

#endif // GRPC_SERVER_H
