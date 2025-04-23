#include <DataRetrieval.h>

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
        Logger::getInstance().log("Destructor disconnect error: " + std::string(exc.what()));
    }
}

void DataRetrieval::start() {
    try {
        m_client.connect(m_connOpts)->wait();
        Logger::getInstance().log("MQTT connected to broker.");
        m_client.subscribe(m_topic, 1)->wait();
        Logger::getInstance().log("Subscribed to MQTT topic: " + m_topic);
    } catch (const mqtt::exception& exc) {
        Logger::getInstance().log("Connection/subscription error: " + std::string(exc.what()));
    }
}

void DataRetrieval::stop() {
    try {
        if (m_client.is_connected()) {
            m_client.disconnect()->wait();
            Logger::getInstance().log("MQTT client disconnected.");
        }
    } catch (const mqtt::exception& exc) {
        Logger::getInstance().log("Disconnection error: " + std::string(exc.what()));
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

        if (topic.empty() || payload.empty()) {
            Logger::getInstance().log("Empty topic or payload, ignoring.");
            return;
        }

        if (m_messageCallback) {
            m_messageCallback(payload);
        } else {
            broker::globalQueue.push(payload);  // updates
        }

        Logger::getInstance().log("Message processed.");
    } catch (const std::exception& e) {
        Logger::getInstance().log("message_arrived exception: " + std::string(e.what()));
    }
}

void DataRetrieval::connected(const std::string& cause) {
    Logger::getInstance().log("DataRetrieval::connected() called: (cause: " + cause + ")");
}

void DataRetrieval::connection_lost(const std::string& cause) {
    Logger::getInstance().log("DataRetrieval::connection_lost() called: (cause: " + cause + ")");
}

void DataRetrieval::delivery_complete(const mqtt::delivery_token_ptr token) {
    Logger::getInstance().log("DataRetrieval::delivery_complete() called" "(token id: " + std::to_string(token ? token->get_message_id() : -1) + ")");
}

void DataRetrieval::on_success(const mqtt::token& tok) {
    Logger::getInstance().log("DataRetrieval::on_success() called" "(token id: " + std::to_string(tok.get_message_id()) + ")");
}

void DataRetrieval::on_failure(const mqtt::token& tok) {
    Logger::getInstance().log("DataRetrieval::on_failure() called" "(token id: " + std::to_string(tok.get_message_id()) + ")");
}

