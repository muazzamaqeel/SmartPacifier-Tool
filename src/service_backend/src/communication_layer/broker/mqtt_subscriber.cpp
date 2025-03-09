#include "mqtt_subscriber.h"

#define QOS 1

// Constructor
MQTTSubscriber::MQTTSubscriber(const std::string& broker, const std::string& client_id, const std::string& topic)
        : topic_(topic), connected_(false) {
    MQTTAsync_create(&client_, broker.c_str(), client_id.c_str(), MQTTCLIENT_PERSISTENCE_NONE, NULL);
    MQTTAsync_setCallbacks(client_, this, onConnectionLost, onMessageArrived, onDeliveryComplete);
}

// Connection lost callback
void MQTTSubscriber::onConnectionLost(void* context, char* cause) {
    std::cerr << "Connection lost: " << cause << std::endl;
    auto* subscriber = static_cast<MQTTSubscriber*>(context);
    subscriber->connected_ = false;
}

// Message arrived callback
int MQTTSubscriber::onMessageArrived(void* context, char* topicName, int topicLen, MQTTAsync_message* message) {
    std::cout << "Message received on topic: " << topicName << std::endl;

    std::string payload(static_cast<char*>(message->payload), message->payloadlen);
    std::cout << "Raw Payload: " << payload << std::endl;

    MQTTAsync_freeMessage(&message);
    MQTTAsync_free(topicName);
    return 1;
}

// Delivery complete callback
void MQTTSubscriber::onDeliveryComplete(void* context, MQTTAsync_token token) {
    std::cout << "Delivery complete for token: " << token << std::endl;
}

// Start MQTT connection and subscribe to topic
void MQTTSubscriber::start() {
    MQTTAsync_connectOptions conn_opts = MQTTAsync_connectOptions_initializer;
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    conn_opts.context = this;  // Critical Fix: Pass `this` context

    conn_opts.onSuccess = [](void* context, MQTTAsync_successData* response) {
        std::cout << "✅ Connected to broker. Now subscribing to topic: Pacifier/#" << std::endl;

        MQTTSubscriber* subscriber = static_cast<MQTTSubscriber*>(context);

        MQTTAsync_responseOptions opts = MQTTAsync_responseOptions_initializer;
        opts.context = subscriber;  // Critical Fix: Pass subscriber object
        opts.onSuccess = [](void* context, MQTTAsync_successData* response) {
            std::cout << "✅ Subscription successful." << std::endl;
        };
        opts.onFailure = [](void* context, MQTTAsync_failureData* response) {
            std::cerr << "❌ Subscription failed with error code: " << response->code << std::endl;
        };

        int rc = MQTTAsync_subscribe(subscriber->client_, "Pacifier/#", QOS, &opts);
        if (rc != MQTTASYNC_SUCCESS) {
            std::cerr << "❌ Subscription request failed with code: " << rc << std::endl;
        }
    };

    conn_opts.onFailure = [](void* context, MQTTAsync_failureData* response) {
        std::cerr << "❌ Failed to connect to broker with error code: " << response->code << std::endl;
    };

    if (MQTTAsync_connect(client_, &conn_opts) != MQTTASYNC_SUCCESS) {
        std::cerr << "❌ Failed to start connection process!" << std::endl;
    }
}


// Stop MQTT connection
void MQTTSubscriber::stop() {
    if (connected_) {
        MQTTAsync_disconnectOptions opts = MQTTAsync_disconnectOptions_initializer;
        MQTTAsync_disconnect(client_, &opts);
    }
    MQTTAsync_destroy(&client_);
}
