#pragma once

#include <MessageQueue.h>

namespace broker {
    inline MessageQueue<std::string>& globalQueue() {
        static MessageQueue<std::string> instance;
        return instance;
    }
}
