#ifndef SERVICE_BACKEND_MQTT_HANDLER_H
#define SERVICE_BACKEND_MQTT_HANDLER_H

// Let Asio know it’s standalone
#define ASIO_STANDALONE
#include <asio.hpp>
#include <memory>
#include <atomic>

class mqtt_handler
{
public:
    // Note: now using asio::io_context
    mqtt_handler(asio::io_context& ioc, unsigned short port);

    void start();
    void stop();

private:
    void do_accept();
    void on_accept(const std::error_code& ec, asio::ip::tcp::socket socket);

    asio::io_context&            io_context_;
    asio::ip::tcp::acceptor      acceptor_;
    std::atomic<bool>            running_{false};
};

#endif // SERVICE_BACKEND_MQTT_HANDLER_H
