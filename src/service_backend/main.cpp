#include <filesystem>
#include <iostream>
#include "src/mqtt/brokercheck_os.h"
using namespace std;
int main() {
    std::cout << "Current Working Directory: "
              << filesystem::current_path() << endl;
    BrokerCheckOS brokerCheck;
    brokerCheck.checkAndStartBroker();

    return 0;
}
