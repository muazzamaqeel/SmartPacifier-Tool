#pragma once

#include <string>
#include <mqtt/async_client.h>
#include <functional>

class DataRetrieval : public virtual mqtt::callback, public virtual mqtt::iaction_listener {
public:
    DataRetrieval(const std::string& broker, const std::string& client_id, const std::string& topic);
    virtual ~DataRetrieval();

    DataRetrieval(const DataRetrieval&) = delete;
    DataRetrieval& operator=(const DataRetrieval&) = delete;
    DataRetrieval(DataRetrieval&&) noexcept = delete;
    DataRetrieval& operator=(DataRetrieval&&) noexcept = delete;

    void start();
    void stop();
    void setMessageCallback(std::function<void(const std::string&)> callback);

    /// Called when the client has successfully connected to the MQTT broker.
    void connected(const std::string&) override {}
    /// Called when the connection to the MQTT broker is lost.
    void connection_lost(const std::string&) override {}
    /// Called whenever a new message arrives with a subscribed topic.
    void message_arrived(mqtt::const_message_ptr msg) override;
    /// Called when a published message has been successfully delivered.
    void delivery_complete(mqtt::delivery_token_ptr) override {}
    /// Called when an asynchronous action (e.g. connect, subscribe) succeeds.
    void on_success(const mqtt::token&) override {}
    /// Called when an asynchronous action (e.g. connect, subscribe) fails.
    void on_failure(const mqtt::token&) override {}

private:
    std::string m_topic;
    mqtt::async_client m_client;
    mqtt::connect_options m_connOpts;
    std::function<void(const std::string&)> m_messageCallback;
};