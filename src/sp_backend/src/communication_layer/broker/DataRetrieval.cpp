#include "DataRetrieval.h"
#include <iostream>
#include <chrono>
#include <thread>

DataRetrieval::DataRetrieval(const std::string& broker, const std::string& client_id, const std::string& topic)
        : topic_(topic), client_(broker, client_id)
{
    // Set this object as the callback for connection, message, etc.
    client_.set_callback(*this);
    connOpts_.set_clean_session(true);
}

DataRetrieval::~DataRetrieval() {
    try {
        if (client_.is_connected()) {
            client_.disconnect()->wait();
        }
    } catch (const mqtt::exception& exc) {
        std::cerr << "Error during disconnect in destructor: " << exc.what() << std::endl;
    }
}
void DataRetrieval::start() {
    try {
        std::cout << "Connecting to broker..." << std::endl;
        // Connect asynchronously. The action listener (this) will be notified.
        client_.connect(connOpts_, nullptr, *this);
    } catch (const mqtt::exception& exc) {
        std::cerr << "Error connecting: " << exc.what() << std::endl;
    }
}

void DataRetrieval::stop() {
    try {
        if (client_.is_connected()) {
            client_.disconnect()->wait();
            std::cout << "Client disconnected successfully." << std::endl;
        }
    } catch (const mqtt::exception& exc) {
        std::cerr << "Error disconnecting: " << exc.what() << std::endl;
    }
}



// Callback: invoked after a successful connection.
void DataRetrieval::connected(const std::string& cause) {
    std::cout << "Connected to broker." << std::endl;
    try {
        std::cout << "Subscribing to topic: " << topic_ << std::endl;
        // Subscribe to the topic with Quality of Service level 1.
        client_.subscribe(topic_, 1, nullptr, *this);
    } catch (const mqtt::exception& exc) {
        std::cerr << "Error subscribing: " << exc.what() << std::endl;
    }
}

// Callback: invoked if the connection is lost.
void DataRetrieval::connection_lost(const std::string& cause) {
    std::cout << "Connection lost: " << cause << std::endl;
}

// Callback: invoked when a message is received.
void DataRetrieval::message_arrived(mqtt::const_message_ptr msg) {
    std::cout << "Message arrived on topic: " << msg->get_topic() << std::endl;
    std::cout << "Payload: " << msg->to_string() << std::endl;
}

// Callback: delivery complete (not used for subscribers).
void DataRetrieval::delivery_complete(mqtt::delivery_token_ptr token) {
    // Not needed for a subscriber.
}

// Action listener callback: invoked when an action completes successfully.
void DataRetrieval::on_success(const mqtt::token& tok) {
    std::cout << "Operation successful." << std::endl;
}

// Action listener callback: invoked when an action fails.
void DataRetrieval::on_failure(const mqtt::token& tok) {
    std::cerr << "Operation failed." << std::endl;
}
