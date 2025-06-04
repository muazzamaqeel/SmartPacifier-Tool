#include "DataRetrieval.h"
#include <GlobalMessageQueue.h>
#include <communication_layer/debug/Logger.h>
#include <mqtt/exception.h>

DataRetrieval::DataRetrieval(const std::string& broker,
                             const std::string& client_id,
                             const std::string& topic)
  : m_topic(topic)
  , m_client(broker, client_id)
  , m_callbackHandler(*this)
  , m_actionListener(*this)
{
    // wire up the one mqtt::callback
    m_client.set_callback(m_callbackHandler);
    m_connOpts.set_clean_session(true);

    Logger::getInstance().log("MQTT client initialized.");
}

DataRetrieval::~DataRetrieval() {
    try {
        if (m_client.is_connected()) {
            m_client.disconnect()->wait();
        }
    }
    catch (const mqtt::exception& exc) {
        Logger::getInstance().log("Destructor disconnect error: " + std::string(exc.what()));
    }
}

void DataRetrieval::start() {
    try {
        m_client.connect(m_connOpts)->wait();
        Logger::getInstance().log("MQTT connected to broker.");
        m_client.subscribe(m_topic, 1)->wait();
        Logger::getInstance().log("Subscribed to MQTT topic: " + m_topic);
    }
    catch (const mqtt::exception& exc) {
        Logger::getInstance().log("Connection/subscription error: " + std::string(exc.what()));
    }
}

void DataRetrieval::stop() {
    try {
        if (m_client.is_connected()) {
            m_client.disconnect()->wait();
            Logger::getInstance().log("MQTT client disconnected.");
        }
    }
    catch (const mqtt::exception& exc) {
        Logger::getInstance().log("Disconnection error: " + std::string(exc.what()));
    }
}

void DataRetrieval::setMessageCallback(const std::function<void(const std::string&)>& callback) {
    m_messageCallback = callback;
}

void DataRetrieval::onMessageArrived(mqtt::const_message_ptr msg) const {
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
        }
        else {
            broker::globalQueue().push(payload);
        }

        Logger::getInstance().log("Message processed.");
    }
    catch (const std::exception& e) {
        Logger::getInstance().log("message_arrived exception: " + std::string(e.what()));
    }
}

void DataRetrieval::onConnectionLost(const std::string& cause) {
    Logger::getInstance().log("DataRetrieval::connection_lost() called: (cause: " + cause + ")");
}

void DataRetrieval::onDeliveryComplete(const mqtt::delivery_token_ptr &tok) {
    Logger::getInstance().log(
      "DataRetrieval::delivery_complete() called (token id: " +
      std::to_string(tok ? tok->get_message_id() : -1) + ")");
}

void DataRetrieval::onActionSuccess(const mqtt::token& tok) {
    Logger::getInstance().log(
      "DataRetrieval::on_success() called (token id: " +
      std::to_string(tok.get_message_id()) + ")");
}

void DataRetrieval::onActionFailure(const mqtt::token& tok) {
    Logger::getInstance().log(
      "DataRetrieval::on_failure() called (token id: " +
      std::to_string(tok.get_message_id()) + ")");
}
