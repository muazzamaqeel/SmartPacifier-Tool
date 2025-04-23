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
                std::lock_guard<std::mutex> lk(m_mutex);
                m_queue.push(std::move(item));
            }
            m_cv.notify_one();

            if (m_batchCallback && m_queue.size() >= m_batchThreshold) {
                std::vector<T> batch;
                {
                    std::lock_guard<std::mutex> lk(m_mutex);
                    for (size_t i = 0; i < m_batchThreshold; ++i) {
                        batch.push_back(std::move(m_queue.front()));
                        m_queue.pop();
                    }
                }
                m_batchCallback(batch);
            }
        }

        // Block until at least one item is available, then pop and return it.
        T pop() {
            std::unique_lock<std::mutex> lk(m_mutex);
            m_cv.wait(lk, [&]{ return !m_queue.empty(); });
            T item = std::move(m_queue.front());
            m_queue.pop();
            return item;
        }

        // Register a callback to fire once `threshold` items accumulate.
        void setBatchCallback(BatchCallback cb, size_t threshold) {
            std::lock_guard<std::mutex> lk(m_mutex);
            m_batchCallback  = std::move(cb);
            m_batchThreshold = threshold;
        }

    private:
        std::queue<T>              m_queue;
        std::mutex                 m_mutex;
        std::condition_variable    m_cv;
        BatchCallback              m_batchCallback;
        size_t                     m_batchThreshold = 1;
    };

}