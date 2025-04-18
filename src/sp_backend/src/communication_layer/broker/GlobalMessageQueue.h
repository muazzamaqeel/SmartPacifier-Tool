#pragma once

#include <condition_variable>
#include <mutex>
#include <queue>
#include <string>

namespace broker {
    inline std::queue<std::string>           globalQueue;
    inline std::mutex                         global_queue_mutex;
    inline std::condition_variable            cv_global_queue;
}
