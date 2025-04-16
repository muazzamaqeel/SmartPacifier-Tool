#pragma once
#include <queue>
#include <string>
#include <mutex>
#include <condition_variable>

inline std::queue<std::string> globalQueue;
inline std::mutex globalMutex;
inline std::condition_variable globalCV;

