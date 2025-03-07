#include "communication_layer/mqtt/MyMQTTClient.h"
#include <mosquittopp.h>
#include <iostream>
int main() {
    mosqpp::lib_init();
    MyMQTTClient client("client_id", "localhost", 1883);
    client.loop_forever();
    mosqpp::lib_cleanup();
    return 0;
}
