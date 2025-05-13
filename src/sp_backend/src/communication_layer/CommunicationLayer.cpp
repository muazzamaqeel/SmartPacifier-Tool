
#include <CommunicationLayer.h>
#include <thread>
#include <grpcpp/grpcpp.h>
#include <broker/Logger.h>
#include <broker/GlobalMessageQueue.h>
#include <broker/BrokerCheck.h>
#include <broker/DataRetrieval.h>
#include <ipc_layer/grpc/gprc_server.h>


CommunicationLayer::CommunicationLayer()
  : running_(false)
  , dataRetrieval_(std::make_shared<DataRetrieval>(
        "tcp://localhost:1883",
        "DataRetrievalClient",
        "Pacifier/#"))
{}

CommunicationLayer::~CommunicationLayer() {
    CommunicationLayer::stopCommunicationServices();
    if (mqttThread_.joinable()) mqttThread_.join();
    if (grpcThread_.joinable()) grpcThread_.join();
}

void CommunicationLayer::startCommunicationServices() {
    if (!BrokerCheck::isMosquittoRunning()) {
        Logger::getInstance().log("Please start Mosquitto broker first.");
        return;
    }
    Logger::getInstance().log("Mosquitto running.");
    running_ = true;
    // Create and own the gRPC service so it outlives this function
    grpcService_ = std::make_unique<GrpcService>(broker::globalQueue());
    // Batch‐callback: Forwarding each batch into the service
    //Value 1 means no batching each message is delivered immediately
    //Value 5 means for example, the call back would wait until 5 messages are queued then send those 5 values at once.
    constexpr size_t batchSize = 1;
    broker::globalQueue().setBatchCallback(
        [this](const std::vector<std::string>& batch) {
            grpcService_->enqueueBatch(batch);
        },
        batchSize
    );
    // Push incoming MQTT payloads into the MessageQueue
    dataRetrieval_->setMessageCallback([](const std::string &msg) {
        broker::globalQueue().push(msg);
    });
    // Start MQTT client thread
    mqttThread_ = std::thread(&CommunicationLayer::runMqttClient, this);
    // Start gRPC server thread
    grpcThread_ = std::thread(&CommunicationLayer::runGrpcServer, this);
}

void CommunicationLayer::stopCommunicationServices() {
    running_ = false;
    dataRetrieval_->stop();
}

void CommunicationLayer::runMqttClient() const {
    Logger::getInstance().log("Starting MQTT...");
    try {
        dataRetrieval_->start();
        Logger::getInstance().log("MQTT stopped.");
    } catch (const std::exception &e) {
        Logger::getInstance().log("MQTT exception: " + std::string(e.what()));
    }
}

void CommunicationLayer::runGrpcServer() const {
    Logger::getInstance().log("Initializing gRPC...");
    const std::string addr("0.0.0.0:50051");

    grpc::ServerBuilder builder;
    builder.AddListeningPort(addr, grpc::InsecureServerCredentials());
    builder.RegisterService(grpcService_.get());

    auto server = builder.BuildAndStart();
    Logger::getInstance().log("gRPC server listening on " + addr);

    try {
        server->Wait();
    } catch (const std::exception &e) {
        Logger::getInstance().log("gRPC exception: " + std::string(e.what()));
    }

    Logger::getInstance().log("gRPC server stopped.");
}
