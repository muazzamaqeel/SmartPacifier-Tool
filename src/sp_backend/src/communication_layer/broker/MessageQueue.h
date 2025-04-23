//
// Created by Muazzam on 18/04/2025.
//

#pragma once

#include <condition_variable>
#include <functional>
#include <mutex>
#include <queue>
#include <vector>

namespace broker {

    template<typename T>
    class MessageQueue {
    public:
        using BatchCallback = std::function<void(const std::vector<T>&)>;

        // Push an item; wake any pop() waiters and fire batch callback if threshold met.
        void push(T item) {
            {
                std::lock_guard<std::mutex> lk(mutex_);
                queue_.push(std::move(item));
            }
            cv_.notify_one();

            if (batchCallback_ && queue_.size() >= batchThreshold_) {
                std::vector<T> batch;
                {
                    std::lock_guard<std::mutex> lk(mutex_);
                    for (size_t i = 0; i < batchThreshold_; ++i) {
                        batch.push_back(std::move(queue_.front()));
                        queue_.pop();
                    }
                }
                batchCallback_(batch);
            }
        }

        // Block until at least one item is available, then pop and return it.
        T pop() {
            std::unique_lock<std::mutex> lk(mutex_);
            cv_.wait(lk, [&]{ return !queue_.empty(); });
            T item = std::move(queue_.front());
            queue_.pop();
            return item;
        }

        // Register a callback to fire once `threshold` items accumulate.
        void setBatchCallback(BatchCallback cb, size_t threshold) {
            std::lock_guard<std::mutex> lk(mutex_);
            batchCallback_  = std::move(cb);
            batchThreshold_ = threshold;
        }

    private:
        std::queue<T>              m_queue;
        std::mutex                 m_mutex;
        std::condition_variable    m_cv;
        BatchCallback              m_batchCallback;
        size_t                     m_batchThreshold = 1;
    };

}