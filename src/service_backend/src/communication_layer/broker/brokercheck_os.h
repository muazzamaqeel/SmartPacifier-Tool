#ifndef SERVICE_BACKEND_BROKERCHECK_OS_H
#define SERVICE_BACKEND_BROKERCHECK_OS_H

#include <iostream>
#include <string>

class BrokerCheckOS {
public:
    BrokerCheckOS();

    static bool isMosquittoInstalled();
    static bool isMosquittoRunning();
    void startMosquitto();
    void checkAndStartBroker();

private:
    static std::string mosquittoPath;

    static void loadConfig();
};

#endif //SERVICE_BACKEND_BROKERCHECK_OS_H
