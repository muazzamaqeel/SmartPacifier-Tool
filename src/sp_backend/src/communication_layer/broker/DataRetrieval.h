#pragma once

#include <string>
#include <mqtt/async_client.h>
#include <functional>

class DataRetrieval : public virtual mqtt::callback,
                      public virtual mqtt::iaction_listener {
public:
    DataRetrieval(const std::string& broker,
                  const std::string& client_id,
                  const std::string& topic);
    ~DataRetrieval();

    DataRetrieval(const DataRetrieval&) = delete;
    DataRetrieval& operator=(const DataRetrieval&) = delete;
    DataRetrieval(DataRetrieval&&) noexcept = delete;
    DataRetrieval& operator=(DataRetrieval&&) noexcept = delete;

    void start();
    void stop();

    void setMessageCallback(const std::function<void(const std::string&)>& callback);

    void connected(const std::string&) override;
    void connection_lost(const std::string&) override;
    void message_arrived(mqtt::const_message_ptr msg) override;
    void delivery_complete(mqtt::delivery_token_ptr) override;
    void on_success(const mqtt::token&) override;
    void on_failure(const mqtt::token&) override;

private:
    std::string m_topic;
    mqtt::async_client m_client;
    mqtt::connect_options m_connOpts;
    std::function<void(const std::string&)> m_messageCallback;
};
