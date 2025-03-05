#include "MyMQTTClient.h"
#include <iostream>

MyMQTTClient::MyMQTTClient(const char* id, const char* host, int port)
        : mosquittopp(id), host_(host), port_(port)
{
    int keepalive = 60;
    int ret = connect(host, port, keepalive);
    if (ret != MOSQ_ERR_SUCCESS) {
        std::cerr << "Failed to connect: " << ret << std::endl;
    }
}

MyMQTTClient::~MyMQTTClient() {
    disconnect();
}

void MyMQTTClient::on_connect(int rc) {
    if (rc == 0) {
        std::cout << "Connected successfully to the MQTT broker." << std::endl;
        // Subscribe to a topic (for example, "test/topic").
        subscribe(nullptr, "Pacifier/#");
        std::cout << "Waiting for data at host: " << host_ << ", port: " << port_ << std::endl;
    } else {
        std::cerr << "Connection failed with code: " << rc << std::endl;
    }
}

void MyMQTTClient::on_message(const struct mosquitto_message* message) {
    if (message->payloadlen) {
        std::cout << "Received message on topic '" << message->topic << "': "
                  << static_cast<char*>(message->payload) << std::endl;
    } else {
        std::cout << "Received an empty message on topic '" << message->topic << "'" << std::endl;
    }
}

void MyMQTTClient::on_subscribe(int mid, int qos_count, const int* granted_qos) {
    std::cout << "Subscription succeeded (mid: " << mid << ")." << std::endl;
}

void MyMQTTClient::on_disconnect(int rc) {
    std::cout << "Disconnected from broker with code: " << rc << std::endl;
}
