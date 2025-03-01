#include "subscriber.h"
#include <nng/nng.h>
#include <nng/protocol/pubsub0/sub.h>
#include <atomic>
#include <thread>
#include <queue>
#include <mutex>
#include <string>
#include <iostream>
#include <cstring>
#include <chrono>

// Global state for the subscriber
static std::atomic<bool> g_running{false};
static std::queue<std::string> g_messageQueue;
static std::mutex g_mutex;
static std::thread g_subscriberThread;

// Subscriber thread function
static void subscriber_thread_func(const char* url) {
    nng_socket sock;
    int rv;

    // Open the SUB socket
    if ((rv = nng_sub_open(&sock)) != 0) {
        std::cerr << "nng_sub_open failed: " << nng_strerror(rv) << std::endl;
        return;
    }

    // Subscribe to all topics (empty string subscribes to everything)
    if ((rv = nng_setopt(sock, NNG_OPT_SUB_SUBSCRIBE, "", 0)) != 0) {
        std::cerr << "nng_setopt failed: " << nng_strerror(rv) << std::endl;
        nng_close(sock);
        return;
    }

    // Connect to the publisher endpoint
    if ((rv = nng_dial(sock, url, nullptr, 0)) != 0) {
        std::cerr << "nng_dial failed: " << nng_strerror(rv) << std::endl;
        nng_close(sock);
        return;
    }

    // Receive loop
    while (g_running.load()) {
        char* buf = nullptr;
        size_t sz = 0;
        rv = nng_recv(sock, &buf, &sz, NNG_FLAG_ALLOC);
        if (rv == 0 && buf != nullptr) {
            std::string msg(buf, sz);
            nng_free(buf, sz);
            {
                std::lock_guard<std::mutex> lock(g_mutex);
                g_messageQueue.push(msg);
            }
        } else {
            // Wait a bit before retrying to avoid busy looping
            std::this_thread::sleep_for(std::chrono::milliseconds(50));
        }
    }

    nng_close(sock);
}

// Exported functions for Flutter FFI
extern "C" {

EXPORT void nng_subscribe_start(const char* url) {
    if (g_running.load()) {
        std::cerr << "Subscriber already running!" << std::endl;
        return;
    }
    g_running.store(true);
    g_subscriberThread = std::thread(subscriber_thread_func, url);
    g_subscriberThread.detach(); // Detach for simplicity; alternatively, manage thread join
}

EXPORT const char* nng_get_message() {
    std::lock_guard<std::mutex> lock(g_mutex);
    if (g_messageQueue.empty()) {
        return "";
    }
    std::string msg = g_messageQueue.front();
    g_messageQueue.pop();
    // Allocate a new buffer to return the message (caller must free it)
    char* result = new char[msg.size() + 1];
    std::memcpy(result, msg.c_str(), msg.size() + 1);
    return result;
}

EXPORT void nng_free_message(const char* msg) {
    delete[] msg;
}

EXPORT void nng_subscribe_stop() {
    g_running.store(false);
    // Optionally, you can wait for the thread to finish here if needed
}

} // extern "C"
