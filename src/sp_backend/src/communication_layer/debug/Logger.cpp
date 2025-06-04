#include <communication_layer/debug/Logger.h>

#include <iostream>
#include <fstream>       // for std::ofstream
#include <chrono>
#include <ctime>

Logger& Logger::getInstance() {
    static Logger instance;
    return instance;
}

Logger::Logger() {
    // use the member m_logFile and correct flag std::ios::app
    m_logFile.open("backend.log", std::ios::app);
}

Logger::~Logger() {
    if (m_logFile.is_open()) {
        m_logFile.close();
    }
}

void Logger::log(const std::string& message) {
    // lock the member mutex
    std::lock_guard<std::mutex> lock(m_logMutex);
    auto now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
    m_logFile << std::ctime(&now) << " - " << message << "\n";
    std::cout << message << std::endl;
}
