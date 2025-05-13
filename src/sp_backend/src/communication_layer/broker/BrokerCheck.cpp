#include "BrokerCheck.h"

#ifdef _WIN32
  #include <windows.h>
  #include <tlhelp32.h>
  #include <cstring>
#elif defined(__linux__)
  #include <cstdlib>
#endif

#include <mqtt/client.h>
#include <mqtt/connect_options.h>

bool BrokerCheck::canConnect(const std::string& address,
                             const std::string& clientId,
                             int /*timeoutSeconds*/) {
    try {
        // create a Paho MQTT synchronous client
        mqtt::client cli(address, clientId);
        // prepare clean-session connect options
        auto connOpts = mqtt::connect_options_builder()
                            .clean_session(true)
                            .finalize();
        cli.connect(connOpts);
        cli.disconnect();
        return true;
    }
    catch (const mqtt::exception&) {
        return false;
    }
}