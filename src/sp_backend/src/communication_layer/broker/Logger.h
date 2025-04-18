#pragma once

#include <string>
#include <mutex>
#include <fstream>

class Logger {
public:
    static Logger& getInstance();
    void log(const std::string& message);
private:
    Logger();       //Constructor
    ~Logger();      //Destructor

    Logger(const Logger&) = delete;                 //Copy Constructor
    Logger& operator=(const Logger&) = delete;      //Copy Assignment
    Logger(Logger&&) noexcept = delete;             //Move Constructor
    Logger& operator=(Logger&&) noexcept = delete;  //Move Assignment

    std::mutex m_logMutex;
    std::ofstream m_logFile;
};
