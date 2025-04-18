#pragma once

#include "MessageQueue.h"

namespace broker {
    // single global, thread-safe, blocking queue of strings
    inline MessageQueue<std::string> globalQueue;
}
