#include "platform_layer/PlatformFactory.h"
#include "communication_layer/broker/Logger.h"
#include <exception>
#include <string>

int main() {
    try {
        auto platformManager = createPlatformManager();
        if (!platformManager) {
            Logger::getInstance().log("Unsupported platform.");
            return 1;
        }
        platformManager->runBackend();
    } catch (const std::exception &e) {
        Logger::getInstance().log("CRITICAL ERROR in main(): " + std::string(e.what()));
    } catch (...) {
        Logger::getInstance().log("CRITICAL UNKNOWN ERROR in main()!");
    }
    return 0;
}
