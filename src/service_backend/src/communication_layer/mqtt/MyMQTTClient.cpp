#include "MyMQTTClient.h"
#include <iostream>
using namespace std;

MyMQTTClient::MyMQTTClient(const char* id, const char* host, int port) : mosquittopp(id), host_(host), port_(port){
    int keepalive = 60;
    int ret = connect(host, port, keepalive);
    if (ret != MOSQ_ERR_SUCCESS) {
        cerr << "Failed to connect: " << ret << endl;
    }
}
MyMQTTClient::~MyMQTTClient() {
    disconnect();
}
void MyMQTTClient::on_connect(int rc) {
    if (rc == 0) {
        cout << "Connected successfully to the MQTT broker." << endl;
        subscribe(nullptr, "Pacifier/#");
        cout << "Waiting for data at host: " << host_ << ", port: " << port_ << endl;
    } else {
        cerr << "Connection failed with code: " << rc << endl;
    }
}
void MyMQTTClient::on_message(const struct mosquitto_message* message) {
    if (message->payloadlen) {
        cout << "Received message on topic '" << message->topic << "': "
                  << static_cast<char*>(message->payload) << endl;
    } else {
        cout << "Received an empty message on topic '" << message->topic << "'" << endl;
    }
}
void MyMQTTClient::on_subscribe(int mid, int qos_count, const int* granted_qos) {
    cout << "Subscription succeeded (mid: " << mid << ")." << endl;
}
void MyMQTTClient::on_disconnect(int rc) {
    std::cout << "Disconnected from broker with code: " << rc << std::endl;
}
