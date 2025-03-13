#ifndef SP_BACKEND_BROKERCHECK_H
#define SP_BACKEND_BROKERCHECK_H

class BrokerCheck {
public:
    // Returns true if the Mosquitto broker is running.
    static bool isMosquittoRunning();
};

#endif // SP_BACKEND_BROKERCHECK_H
