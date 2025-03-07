#ifndef NNG_HANDLER_H
#define NNG_HANDLER_H

#include <string>

// Make sure CMake points to the directory that has these headers:
#include <nng/nng.h>
#include <nng/protocol/pubsub0/pub.h>

class NNGHandler {
public:
    NNGHandler();
    ~NNGHandler();

    // Publish a message via NNG pub socket
    void send_message(const std::string& message);

private:
    nng_socket pub_socket_;
};

#endif // NNG_HANDLER_H
