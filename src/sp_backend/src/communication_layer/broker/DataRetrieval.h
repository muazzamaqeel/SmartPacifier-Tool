#pragma once

#include <string>
#include <functional>
#include <mqtt/async_client.h>

class DataRetrieval {
public:
    DataRetrieval(const std::string& broker,
                  const std::string& client_id,
                  const std::string& topic);
    ~DataRetrieval();

    DataRetrieval(const DataRetrieval&) = delete;
    DataRetrieval& operator=(const DataRetrieval&) = delete;
    DataRetrieval(DataRetrieval&&) = delete;
    DataRetrieval& operator=(DataRetrieval&&) = delete;

    void start();
    void stop();
    void setMessageCallback(const std::function<void(const std::string&)>& callback);

private:

    class CallbackHandler : public virtual mqtt::callback {
    public:
        explicit CallbackHandler(DataRetrieval& parent)
          : parent_(parent) {}
        void connection_lost(const std::string& cause) override {
            parent_.onConnectionLost(cause);
        }
        void message_arrived(mqtt::const_message_ptr msg) override {
            parent_.onMessageArrived(std::move(msg));
        }
        void delivery_complete(mqtt::delivery_token_ptr tok) override {
            parent_.onDeliveryComplete(tok);
        }
    private:
        DataRetrieval& parent_;
    };

    class ActionListener : public virtual mqtt::iaction_listener {
    public:
        explicit ActionListener(DataRetrieval& parent)
          : parent_(parent) {}
        void on_success(const mqtt::token& tok) override {
            parent_.onActionSuccess(tok);
        }
        void on_failure(const mqtt::token& tok) override {
            parent_.onActionFailure(tok);
        }
    private:
        DataRetrieval& parent_;
    };

    void onConnectionLost(const std::string& cause);
    void onMessageArrived(mqtt::const_message_ptr msg) const;
    void onDeliveryComplete(const mqtt::delivery_token_ptr &tok);
    void onActionSuccess(const mqtt::token& tok);
    void onActionFailure(const mqtt::token& tok);


    std::string                                m_topic;
    mqtt::async_client                         m_client;
    mqtt::connect_options                      m_connOpts;
    std::function<void(const std::string&)>    m_messageCallback;

    CallbackHandler    m_callbackHandler;
    ActionListener     m_actionListener;
};
