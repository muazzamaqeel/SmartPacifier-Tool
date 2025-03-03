#include "mqtt_handler.h"
#include <iostream>

mqtt_handler::mqtt_handler(asio::io_context& ioc, unsigned short port)
        : io_context_(ioc),
          acceptor_(ioc, asio::ip::tcp::endpoint(asio::ip::tcp::v4(), port))
{
}

void mqtt_handler::start()
{
    running_.store(true);
    do_accept();
    std::cout << "[mqtt_handler] Broker started on port "
              << acceptor_.local_endpoint().port() << std::endl;
}

void mqtt_handler::stop()
{
    running_.store(false);

    std::error_code ec;
    acceptor_.close(ec);
    if (ec) {
        std::cerr << "[mqtt_handler] Error closing acceptor: "
                  << ec.message() << std::endl;
    } else {
        std::cout << "[mqtt_handler] Broker stopped." << std::endl;
    }
}

void mqtt_handler::do_accept()
{
    if (!running_.load()) return;

    acceptor_.async_accept(
            [this](std::error_code ec, asio::ip::tcp::socket socket)
            {
                on_accept(ec, std::move(socket));
            }
    );
}

void mqtt_handler::on_accept(const std::error_code& ec, asio::ip::tcp::socket socket)
{
    if (!ec && running_.load())
    {
        std::cout << "[mqtt_handler] New connection from "
                  << socket.remote_endpoint().address().to_string() << std::endl;

        // Accept the next client
        do_accept();
    }
    else if (ec)
    {
        std::cerr << "[mqtt_handler] Accept error: " << ec.message() << std::endl;
    }
}
