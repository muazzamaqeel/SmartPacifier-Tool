#include "DataRetrieval.h"
#include <utility>
#include "GlobalMessageQueue.h"
#include "Logger.h"

DataRetrieval::DataRetrieval(const std::string& broker,
                             const std::string& client_id,
                             const std::string& topic)
    : m_topic(topic)
    , m_client(broker, client_id)
{
    m_client.set_callback(*this);
    m_connOpts.set_clean_session(true);
    Logger::getInstance().log("MQTT client initialized.");
}

DataRetrieval::~DataRetrieval() {
    try {
        if (m_client.is_connected()) {
            m_client.disconnect()->wait();
        }
    } catch (const mqtt::exception& exc) {
        Logger::getInstance().log(
            "Error during disconnect in destructor: " + std::string(exc.what()));
    }
}

void DataRetrieval::start() {
    try {
        m_client.connect(m_connOpts)->wait();
        Logger::getInstance().log("MQTT connected to broker.");
        m_client.subscribe(m_topic, 1)->wait();
        Logger::getInstance().log("Subscribed to MQTT topic: " + m_topic);
    } catch (const mqtt::exception& exc) {
        Logger::getInstance().log(
            "MQTT connection/subscription error: " + std::string(exc.what()));
    }
}

void DataRetrieval::stop() {
    try {
        if (m_client.is_connected()) {
            m_client.disconnect()->wait();
            Logger::getInstance().log("MQTT client disconnected.");
        }
    } catch (const mqtt::exception& exc) {
        Logger::getInstance().log(
            "MQTT disconnection error: " + std::string(exc.what()));
    }
}

void DataRetrieval::setMessageCallback(const std::function<void(const std::string&)>& callback) {
    m_messageCallback = callback;
}

void DataRetrieval::message_arrived(mqtt::const_message_ptr msg) {
    try {
        Logger::getInstance().log("Incoming MQTT message...");

        if (!msg) {
            Logger::getInstance().log("Received NULL MQTT message, ignoring.");
            return;
        }

        auto topic   = msg->get_topic();
        auto payload = msg->to_string();

        Logger::getInstance().log(
            "Topic: " + (topic.empty() ? "[EMPTY]" : topic));
        Logger::getInstance().log(
            "Payload: " + (payload.empty() ? "[EMPTY]" : payload));

        if (topic.empty() || payload.empty()) {
            Logger::getInstance().log(
                "MQTT message missing topic or payload, ignoring.");
            return;
        }

        if (m_messageCallback) {
            m_messageCallback(payload);
        } else {
            std::lock_guard<std::mutex> lock(broker::global_queue_mutex);
            broker::globalQueue.push(payload);
            broker::cv_global_queue.notify_all();
        }

        Logger::getInstance().log("Message processed.");
    } catch (const std::exception& e) {
        Logger::getInstance().log(
            "Exception in message_arrived(): " + std::string(e.what()));
    }
}
