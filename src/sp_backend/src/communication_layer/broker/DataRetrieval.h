#pragma once


#include <string>
#include <mqtt/async_client.h>
#include <functional>

class DataRetrieval : public virtual mqtt::callback, public virtual mqtt::iaction_listener {
public:
    DataRetrieval(const std::string& broker, const std::string& client_id, const std::string& topic);

    virtual ~DataRetrieval();

    void start();
    void stop();

    void setMessageCallback(std::function<void(const std::string&)> callback);

    void connected(const std::string& cause) override;
    void connection_lost(const std::string& cause) override;
    void message_arrived(mqtt::const_message_ptr msg) override;
    void delivery_complete(mqtt::delivery_token_ptr token) override;
    void on_success(const mqtt::token& tok) override;
    void on_failure(const mqtt::token& tok) override;

private:
    std::string m_topic;
    mqtt::async_client m_client;
    mqtt::connect_options m_connOpts;
    std::function<void(const std::string&)> m_messageCallback;

};



