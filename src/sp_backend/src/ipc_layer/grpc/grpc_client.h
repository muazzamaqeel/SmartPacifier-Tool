#pragma once

#include <memory>
#include <string>
#include <grpcpp/grpcpp.h>
#include "myservice.grpc.pb.h"
#include <google/protobuf/empty.pb.h>
#include <sensor_data.pb.h>  // for Protos::SensorData

/// Thin wrapper: open a single client‐stream RPC and call send() repeatedly.
class MyGrpcClient {
public:
    MyGrpcClient() = default;
    ~MyGrpcClient() {
        if (writer_) {
            writer_->WritesDone();
            status_ = writer_->Finish();
        }
    }

    /// Call once before send(). Pass your backend name here.
    void init(const std::string& host = "127.0.0.1",
              int port = 50051,
              const std::string& backendName = "C++ BackEnd")
    {
        backend_name_ = backendName;
        const auto target = host + ":" + std::to_string(port);
        channel_ = grpc::CreateChannel(
            target, grpc::InsecureChannelCredentials());
        stub_    = myservice::MyService::NewStub(channel_);
        context_ = std::make_unique<grpc::ClientContext>();

        // *** Inject the backend-name as initial metadata ***
        context_->AddMetadata("backend-name", backend_name_);

        writer_  = stub_->PublishSensorData(context_.get(), &response_);
    }

    /// Streams one SensorData message down the open stream.
    /// (We leave the payload untouched—backend name travels in metadata.)
    void send(const Protos::SensorData& sd) const {
        myservice::PayloadMessage msg;
        *msg.mutable_sensor_data() = sd;
        writer_->Write(msg);
    }

private:
    std::shared_ptr<grpc::Channel>                              channel_;
    std::unique_ptr<myservice::MyService::Stub>                 stub_;
    std::unique_ptr<grpc::ClientContext>                        context_;
    std::unique_ptr<grpc::ClientWriter<myservice::PayloadMessage>> writer_;
    google::protobuf::Empty                                      response_;
    grpc::Status                                                 status_;
    std::string                                                  backend_name_;
};
