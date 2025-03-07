#include "brokercheck_os.h"
#include <fstream>
#include <sstream>
#include <cstdlib>
#include "../external_libs/json/json.hpp"
#include <filesystem>

std::string BrokerCheckOS::mosquittoPath = "";
using json = nlohmann::json;

#ifdef _WIN32
#define OS_WINDOWS
#else
#define OS_LINUX
#endif

BrokerCheckOS::BrokerCheckOS() {
    loadConfig();
}


void BrokerCheckOS::loadConfig() {
    std::filesystem::path currentPath = std::filesystem::current_path();
    std::filesystem::path projectRoot = currentPath.parent_path();
    std::filesystem::path configPath = projectRoot / "configuration" / "config.json";
    std::ifstream configFile(configPath);
    if (!configFile.is_open()) {
        std::cerr << "Error: Could not open config.json at " << configPath << std::endl;
        return;
    }
    json config;
    configFile >> config;
    configFile.close();
    mosquittoPath = config.value("windows_mosquitto_path", "");
}



bool BrokerCheckOS::isMosquittoInstalled() {
#ifdef OS_WINDOWS
    if (mosquittoPath.empty()) {
        std::cerr << "Mosquitto path is not set in config.json!" << std::endl;
        return false;
    }

    std::ifstream mosquittoFile(mosquittoPath);
    return mosquittoFile.good();
#else
    return (system("which mosquitto > /dev/null 2>&1") == 0);
#endif
}

bool BrokerCheckOS::isMosquittoRunning() {
#ifdef OS_WINDOWS
    return (system("tasklist | findstr mosquitto.exe >nul 2>nul") == 0);
#else
    return (system("pgrep mosquitto > /dev/null") == 0);
#endif
}

void BrokerCheckOS::startMosquitto() {
#ifdef OS_WINDOWS
    if (mosquittoPath.empty()) {
        std::cerr << "Mosquitto path is missing in config.json!" << std::endl;
        return;
    }

    std::string command = "\"" + mosquittoPath + "\" -v";
    system(command.c_str());
#else
    system("mosquitto -d");  // Run in daemon mode
#endif
}

void BrokerCheckOS::checkAndStartBroker() {
    std::cout << "Checking for MQTT Mosquitto..." << std::endl;

    if (isMosquittoInstalled()) {
        std::cout << "Mosquitto is installed." << std::endl;

        if (!isMosquittoRunning()) {
            std::cout << "Mosquitto is not running. Starting it now..." << std::endl;
            startMosquitto();
        } else {
            std::cout << "Mosquitto is already running." << std::endl;
        }
    } else {
        std::cout << "Mosquitto is not installed. Please install it first." << std::endl;
    }
}
