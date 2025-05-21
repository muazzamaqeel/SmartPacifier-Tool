#pragma once

#include <string>

class BrokerCheck {
public:
    static bool isMosquittoRunning();
    static bool canConnect(const std::string& address,
                           const std::string& clientId,
                           int timeoutSeconds = 5);
};
