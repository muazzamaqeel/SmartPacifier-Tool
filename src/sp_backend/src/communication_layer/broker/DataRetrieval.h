#ifndef SP_BACKEND_DATARETRIEVAL_H
#define SP_BACKEND_DATARETRIEVAL_H

#include <string>
#include "mqtt/async_client.h"

// DataRetrieval encapsulates a subscriber that connects to a broker,
// subscribes to a topic, and prints incoming messages.
class DataRetrieval : public virtual mqtt::callback, public virtual mqtt::iaction_listener {
public:
    // Constructor: provide broker URL, client ID, and topic to subscribe to.
    DataRetrieval(const std::string& broker, const std::string& client_id, const std::string& topic);

    // Destructor disconnects from the broker.
    ~DataRetrieval();

    // Start the connection and subscription process.
    void start();

    // Stop the connection.
    void stop();

    // --- mqtt::callback overrides ---
    // Called when the connection is successfully established.
    void connected(const std::string& cause) override;

    // Called if the connection is lost.
    void connection_lost(const std::string& cause) override;

    // Called when a message arrives.
    void message_arrived(mqtt::const_message_ptr msg) override;

    // Called when a message delivery is complete (not used for subscribers).
    void delivery_complete(mqtt::delivery_token_ptr token) override;

    // --- mqtt::iaction_listener overrides ---
    // Called when an action (e.g. connect or subscribe) succeeds.
    void on_success(const mqtt::token& tok) override;

    // Called when an action fails.
    void on_failure(const mqtt::token& tok) override;

private:
    std::string topic_;
    mqtt::async_client client_;
    mqtt::connect_options connOpts_;
};

#endif // SP_BACKEND_DATARETRIEVAL_H
