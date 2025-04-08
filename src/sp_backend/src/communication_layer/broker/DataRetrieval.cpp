#include "DataRetrieval.h"
#include "GlobalMessageQueue.h"
#include "Logger.h"

DataRetrieval::DataRetrieval(const std::string& broker, const std::string& client_id, const std::string& topic)
    : topic_(topic), client_(broker, client_id) {
    client_.set_callback(*this);
    connOpts_.set_clean_session(true);
    Logger::getInstance().log("MQTT client initialized.");
}

DataRetrieval::~DataRetrieval() {
    try {
        if (client_.is_connected()) {
            client_.disconnect()->wait();
        }
    } catch (const mqtt::exception& exc) {
        Logger::getInstance().log("Error during disconnect in destructor: " + std::string(exc.what()));
    }
}

void DataRetrieval::start() {
    try {
        // Synchronously connect
        client_.connect(connOpts_)->wait();
        Logger::getInstance().log("MQTT connected to broker.");

        // Subscribe to your topic with QoS=1
        client_.subscribe(topic_, 1)->wait();
        Logger::getInstance().log("✅ Subscribed to MQTT topic: " + topic_);
    }
    catch (const mqtt::exception& exc) {
        Logger::getInstance().log("MQTT connection/subscription error: " + std::string(exc.what()));
    }
}

void DataRetrieval::stop() {
    try {
        if (client_.is_connected()) {
            client_.disconnect()->wait();
            Logger::getInstance().log("MQTT client disconnected.");
        }
    } catch (const mqtt::exception& exc) {
        Logger::getInstance().log("MQTT disconnection error: " + std::string(exc.what()));
    }
}

void DataRetrieval::setMessageCallback(std::function<void(const std::string&)> callback) {
    messageCallback_ = callback;
}

void DataRetrieval::message_arrived(mqtt::const_message_ptr msg) {
    try {
        Logger::getInstance().log("📩 Incoming MQTT message...");

        if (!msg) {
            Logger::getInstance().log("⚠️ Received NULL MQTT message, ignoring.");
            return;
        }

        std::string topic = msg->get_topic();
        std::string payload = msg->to_string();

        Logger::getInstance().log("   ├─ Topic: " + (topic.empty() ? "[EMPTY]" : topic));
        Logger::getInstance().log("   ├─ Payload: " + (payload.empty() ? "[EMPTY]" : payload));

        if (topic.empty()) {
            Logger::getInstance().log("⚠️ MQTT message has empty topic, ignoring.");
            return;
        }

        if (payload.empty()) {
            Logger::getInstance().log("⚠️ MQTT message has empty payload, ignoring.");
            return;
        }

        // If a message callback has been set, call it.
        if (messageCallback_) {
            messageCallback_(payload);
        } else {
            // Default behavior: Store message in global queue
            {
                std::lock_guard<std::mutex> lock(globalMutex);
                globalQueue.push(payload);
            }
            // Notify gRPC server
            globalCV.notify_one();
        }

        Logger::getInstance().log("✅ Message processed.");

    } catch (const std::exception &e) {
        Logger::getInstance().log("🔥 Exception in message_arrived(): " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("🔥 Unknown Exception in message_arrived()!");
    }
}

void DataRetrieval::connected(const std::string&) {}
void DataRetrieval::connection_lost(const std::string&) {}
void DataRetrieval::delivery_complete(mqtt::delivery_token_ptr) {}
void DataRetrieval::on_success(const mqtt::token&) {}
void DataRetrieval::on_failure(const mqtt::token&) {}
