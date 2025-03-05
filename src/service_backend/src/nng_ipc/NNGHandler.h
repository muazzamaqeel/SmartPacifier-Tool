#ifndef SERVICE_BACKEND_NNGHANDLER_H
#define SERVICE_BACKEND_NNGHANDLER_H

#include <string>

class NNGHandler {
public:
    NNGHandler();
    ~NNGHandler();

    void send_message(const std::string& message);
};

#endif //SERVICE_BACKEND_NNGHANDLER_H
