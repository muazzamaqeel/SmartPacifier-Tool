#pragma once

#include <grpcpp/grpcpp.h>
#include <google/protobuf/empty.pb.h>
#include <myservice.grpc.pb.h>
#include <broker/MessageQueue.h>
#include <queue>
#include <mutex>
#include <condition_variable>

class GrpcService final : public myservice::MyService::Service {
public:
    explicit GrpcService(broker::MessageQueue<std::string>& inputQueue)
      : m_inputQueue(inputQueue)
    {}

    // Stream batched messages to the client
    grpc::Status StreamMessages(
        grpc::ServerContext* context,
        const google::protobuf::Empty* request,
        grpc::ServerWriter<myservice::PayloadMessage>* writer
    ) override;

    // Called by the batch callback to enqueue a whole batch
    void enqueueBatch(const std::vector<std::string>& batch) {
        std::lock_guard<std::mutex> lk(m_outMutex);
        for (auto& msg : batch) {
            m_outQueue.push(std::move(msg));
        }
        m_outCV.notify_one();
    }

private:
    broker::MessageQueue<std::string>& m_inputQueue;
    std::queue<std::string>            m_outQueue;
    std::mutex                         m_outMutex;
    std::condition_variable            m_outCV;
};
