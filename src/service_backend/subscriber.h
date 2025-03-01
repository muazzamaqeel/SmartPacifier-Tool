#ifndef SERVICE_BACKEND_SUBSCRIBER_H
#define SERVICE_BACKEND_SUBSCRIBER_H

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Start the subscriber in a background thread, connecting to the given URL.
 * Example URL: "ipc:///tmp/nng.ipc" or "tcp://127.0.0.1:5555"
 */
EXPORT void nng_subscribe_start(const char* url);

/**
 * Retrieve the next message from the subscriber queue.
 * Returns an allocated null-terminated string. If no message is available, returns an empty string.
 * The caller must free the returned memory using nng_free_message().
 */
EXPORT const char* nng_get_message();

/**
 * Free a message pointer returned by nng_get_message().
 */
EXPORT void nng_free_message(const char* msg);

/**
 * Stop the subscriber thread.
 */
EXPORT void nng_subscribe_stop();

#ifdef __cplusplus
}
#endif

#endif // SERVICE_BACKEND_SUBSCRIBER_H
