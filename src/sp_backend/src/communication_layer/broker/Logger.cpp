#include "Logger.h"
#include <iostream>
#include <ctime>
#include <filesystem>
namespace fs = std::filesystem;

Logger::Logger() {

    fs::create_directories("logs");
    logFile.open("logs/backend.log", std::ios::out | std::ios::app);
    if (!logFile.is_open()) {
        std::cerr << "❌ Failed to open log file: backend.log" << std::endl;
    } else {
        log("✅ Logger initialized. Logs will be written to backend.log");
    }
}

Logger::~Logger() {
    if (logFile.is_open()) {
        logFile.close();
    }
}

void Logger::log(const std::string& message) {
    std::lock_guard<std::mutex> lock(logMutex);

    // Get current time
    std::time_t now = std::time(nullptr);
    std::tm* localTime = std::localtime(&now);

    if (logFile.is_open()) {
        logFile << "[" << localTime->tm_hour << ":" << localTime->tm_min << ":" << localTime->tm_sec << "] "
                << message << std::endl;
        logFile.flush();  // Ensure logs are written immediately
    } else {
        std::cerr << "❌ Log file is not open!" << std::endl;
    }
}
