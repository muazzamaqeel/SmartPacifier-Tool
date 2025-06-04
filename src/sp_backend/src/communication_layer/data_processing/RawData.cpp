#include "RawData.h"

#include <communication_layer/debug/Logger.h>
#include <broker/GlobalMessageQueue.h>
#include <sensor_data.pb.h>

#include <cstring>
#include <fstream>
#include <map>
#include <cmath>

RawData::RawData(const std::string& outputFilePath)
  : flattenedFilePath_(outputFilePath)
{}

void RawData::process(const std::string& raw) const {
    Protos::SensorData sd;
    if (!sd.ParseFromString(raw)) {
        Logger::getInstance().log("invalid SensorData – dropping");
        return;
    }

    broker::globalQueue().push(raw);
    Logger::getInstance().log("forwarded raw SensorData");

    // ALSO write raw into text file (decoded)
    std::map<std::string,double> numericMap;
    for (const auto&[fst, snd] : sd.data_map()) {
        const auto &key  = fst;
        const auto &blob = snd;
        size_t len = blob.size();
        if (len % 4) continue;
        for (size_t i = 0; i < len; i += 4) {
            uint32_t bits;
            std::memcpy(&bits, blob.data()+i, 4);
            float f; std::memcpy(&f, &bits, 4);
            double v = std::isfinite(f) ? f : static_cast<double>(static_cast<int32_t>(bits));
            std::string mapKey = (len>4 ? key+"_"+std::to_string(i/4) : key);
            numericMap[mapKey] = v;
        }
    }
    std::ofstream ofs(flattenedFilePath_, std::ios::app);
    if (ofs) {
        for (auto &p : numericMap) ofs << p.first << "=" << p.second << " ";
        ofs << "\n"; ofs.flush();
    }
}
