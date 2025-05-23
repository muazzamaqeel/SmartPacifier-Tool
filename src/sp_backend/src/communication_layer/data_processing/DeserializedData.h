#pragma once

#include <string>

class DeserializedData {
public:
    explicit DeserializedData(const std::string& outputFilePath);
    void process(const std::string& raw);

private:
    std::string flattenedFilePath_;
};
