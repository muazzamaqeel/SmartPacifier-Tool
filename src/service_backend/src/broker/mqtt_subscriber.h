#ifndef SERVICE_BACKEND_MQTT_SUBSCRIBER_H
#define SERVICE_BACKEND_MQTT_SUBSCRIBER_H

#include <iostream>
#include <string>
//#include "../../src/external_libs/vcpkg/packages/paho-mqtt_x64-windows/include/MQTTAsync.h"
//#include "../../src/external_libs/vcpkg/packages/paho-mqtt_x64-windows/include/MQTTClient.h"

class MQTTSubscriber {
public:
    MQTTSubscriber(const std::string& broker, const std::string& client_id, const std::string& topic);
    void start();
    void stop();

private:
    static void onConnectionLost(void* context, char* cause);
    //static int onMessageArrived(void* context, char* topicName, int topicLen, MQTTAsync_message* message);
    //static void onDeliveryComplete(void* context, MQTTAsync_token token);

    //MQTTAsync client_;
    std::string topic_;
    bool connected_;
};

#endif //SERVICE_BACKEND_MQTT_SUBSCRIBER_H
