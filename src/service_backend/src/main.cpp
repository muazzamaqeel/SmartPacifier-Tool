#include "communication_layer/mqtt/MyMQTTClient.h"
#include <mosquittopp.h>
#include <iostream>

int main() {
    // Initialize the Mosquitto C++ library.
    mosqpp::lib_init();

    // Create the MQTT client.
    // Change "localhost" and port if your broker is running elsewhere.
    MyMQTTClient client("client_id", "localhost", 1883);

    // Enter the network loop (this call blocks until disconnect).
    client.loop_forever();

    // Clean up the Mosquitto library resources.
    mosqpp::lib_cleanup();

    return 0;
}
