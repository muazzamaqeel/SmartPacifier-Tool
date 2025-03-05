#ifndef SERVICE_BACKEND_MYMQTTCLIENT_H
#define SERVICE_BACKEND_MYMQTTCLIENT_H

#include <mosquittopp.h>
#include <iostream>
#include <string>

class MyMQTTClient : public mosqpp::mosquittopp {
public:
    // Constructor: initializes the client and connects to the broker.
    MyMQTTClient(const char* id, const char* host, int port);
    virtual ~MyMQTTClient();

    // Callback: invoked when the client connects to the broker.
    void on_connect(int rc) override;
    // Callback: invoked when a message is received.
    void on_message(const struct mosquitto_message* message) override;
    // Optional callback: invoked upon subscription.
    void on_subscribe(int mid, int qos_count, const int* granted_qos) override;
    // Optional callback: invoked when the client disconnects.
    void on_disconnect(int rc) override;

private:
    std::string host_;
    int port_;
};

#endif // SERVICE_BACKEND_MYMQTTCLIENT_H
