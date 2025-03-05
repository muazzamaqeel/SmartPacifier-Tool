#ifndef MY_MQTT_CLIENT_H
#define MY_MQTT_CLIENT_H

#include <mosquittopp.h>
#include <string>

class MyMQTTClient : public mosqpp::mosquittopp {
public:
    MyMQTTClient(const char* id, const char* host, int port);
    ~MyMQTTClient() override;
    void on_connect(int rc) override;
    void on_message(const struct mosquitto_message* message) override;
    void on_subscribe(int mid, int qos_count, const int* granted_qos) override;
    void on_disconnect(int rc) override;

private:
    std::string host_;
    int port_;
};

#endif // MY_MQTT_CLIENT_H
