#include <nng/nng.h>
#include <nng/protocol/pubsub0/pub.h>
#include <iostream>
#include <thread>
#include <chrono>
#include <cstring>
#include <string>

int main() {
    nng_socket sock;
    int rv;

    // Open the PUB socket
    if ((rv = nng_pub_open(&sock)) != 0) {
        std::cerr << "nng_pub_open failed: " << nng_strerror(rv) << std::endl;
        return 1;
    }

    // Define the endpoint (IPC or TCP). Here we use IPC.
    const char* url = "ipc:///tmp/nng.ipc";
    if ((rv = nng_listen(sock, url, nullptr, 0)) != 0) {
        std::cerr << "nng_listen failed: " << nng_strerror(rv) << std::endl;
        nng_close(sock);
        return 1;
    }

    std::cout << "Publisher listening on " << url << std::endl;
    int counter = 0;

    // Publish a message every second
    while (true) {
        std::string msg = "Hello from publisher! Count=" + std::to_string(counter++);
        rv = nng_send(sock, (void*)msg.c_str(), msg.size() + 1, 0);
        if (rv != 0) {
            std::cerr << "nng_send failed: " << nng_strerror(rv) << std::endl;
        }
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    nng_close(sock);
    return 0;
}
