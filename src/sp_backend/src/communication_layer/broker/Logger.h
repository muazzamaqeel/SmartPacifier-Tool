#ifndef LOGGER_H
#define LOGGER_H

#include <string>
#include <mutex>
#include <fstream>

class Logger {
public:
    static Logger& getInstance();
    void log(const std::string& message);
private:
    Logger();
    ~Logger();
    Logger(const Logger&) = delete;
    Logger& operator=(const Logger&) = delete;

    std::mutex logMutex;
    std::ofstream logFile;
};

#endif // LOGGER_H
