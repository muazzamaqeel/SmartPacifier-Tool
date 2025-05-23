#pragma once

#include <string>

class RawData {
public:
    explicit RawData(const std::string& outputFilePath);
    void process(const std::string& raw) const;

private:
    std::string flattenedFilePath_;
};
