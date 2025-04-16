#pragma once
#include <queue>
#include <string>
#include <mutex>
#include <condition_variable>

inline std::queue<std::string> globalQueue;
inline std::mutex global_queue_mutex;
inline std::condition_variable cv_global_queue;

