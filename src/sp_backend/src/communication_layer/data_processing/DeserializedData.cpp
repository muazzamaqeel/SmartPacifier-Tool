#include "DeserializedData.h"

#include <communication_layer/debug/Logger.h>
#include <broker/GlobalMessageQueue.h>
#include <google/protobuf/dynamic_message.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/message.h>
#include <sensor_data.pb.h>

#include <cstring>
#include <fstream>
#include <map>
#include <cmath>

DeserializedData::DeserializedData(const std::string& outputFilePath)
  : flattenedFilePath_(outputFilePath)
{}

void DeserializedData::process(const std::string& raw) {
    Logger::getInstance().log("→ DeserializedData::process() invoked");

    Protos::SensorData sd;
    if (!sd.ParseFromString(raw)) {
        Logger::getInstance().log("invalid SensorData");
        return;
    }

    // Pre-flattened case
    if (sd.data_map_size() != 1) {
        broker::globalQueue().push(raw);
        Logger::getInstance().log(
          "enqueued pre-flattened SensorData ("+
          std::to_string(sd.data_map_size())+" entries)"
        );

        // write out exactly as RawData would
        std::map<std::string,double> numericMap;
        for (const auto& kv : sd.data_map()) {
            const auto &key  = kv.first;
            const auto &blob = kv.second;
            size_t len = blob.size();
            if (len % 4) continue;
            for (size_t i = 0; i < len; i += 4) {
                uint32_t bits; std::memcpy(&bits, blob.data()+i, 4);
                float f; std::memcpy(&f, &bits, 4);
                double v = std::isfinite(f)?f:double(int32_t(bits));
                std::string mk = (len>4? key+"_"+std::to_string(i/4) : key);
                numericMap[mk] = v;
            }
        }
        std::ofstream ofs(flattenedFilePath_, std::ios::app);
        if (ofs) {
            for (auto &p : numericMap) ofs << p.first << "=" << p.second << " ";
            ofs << "\n"; ofs.flush();
        }
        return;
    }

    // Fully nested case
    std::string st = sd.sensor_type();
    if (st.empty()) {
        Logger::getInstance().log("missing sensor_type");
        return;
    }
    st[0] = char(toupper(st[0]));
    const std::string typeName = "Protos." + st + "Data";
    const std::string nested  = sd.data_map().begin()->second;
    sd.mutable_data_map()->clear();

    auto* desc = google::protobuf::DescriptorPool::generated_pool()
                   ->FindMessageTypeByName(typeName);
    if (!desc) {
        Logger::getInstance().log("unknown payload: "+typeName);
        return;
    }
    google::protobuf::DynamicMessageFactory fac;
    std::unique_ptr<google::protobuf::Message> msg(
      fac.GetPrototype(desc)->New()
    );
    if (!msg->ParseFromString(nested)) {
        Logger::getInstance().log("failed to parse nested "+typeName);
        return;
    }

    // Flatten via reflection
    auto* refl = msg->GetReflection();
    auto pack32 = [](uint32_t w){
      char b[4]; memcpy(b,&w,4);
      return std::string(b,4);
    };
    for (int i=0; i<desc->field_count(); ++i) {
        auto* f = desc->field(i);
        if (f->is_repeated()) {
            int N = refl->FieldSize(*msg,f);
            for (int j=0; j<N; ++j) {
                std::string key = f->name()+"_"+std::to_string(j);
                if (f->cpp_type()==google::protobuf::FieldDescriptor::CPPTYPE_FLOAT){
                    float v = refl->GetRepeatedFloat(*msg,f,j);
                    uint32_t bits; memcpy(&bits,&v,4);
                    (*sd.mutable_data_map())[key]=pack32(bits);
                }
                else if (f->cpp_type()==google::protobuf::FieldDescriptor::CPPTYPE_INT32){
                    int32_t v = refl->GetRepeatedInt32(*msg,f,j);
                    (*sd.mutable_data_map())[key]=pack32(uint32_t(v));
                }
            }
        }
        else if (refl->HasField(*msg,f)) {
            std::string key = f->name();
            if (f->cpp_type()==google::protobuf::FieldDescriptor::CPPTYPE_FLOAT){
                float v = refl->GetFloat(*msg,f);
                uint32_t bits; memcpy(&bits,&v,4);
                (*sd.mutable_data_map())[key]=pack32(bits);
            }
            else if (f->cpp_type()==google::protobuf::FieldDescriptor::CPPTYPE_INT32){
                int32_t v = refl->GetInt32(*msg,f);
                (*sd.mutable_data_map())[key]=pack32(uint32_t(v));
            }
        }
    }

    // enqueue flattened bytes
    std::string out = sd.SerializeAsString();
    broker::globalQueue().push(out);
    Logger::getInstance().log(
      "enqueued flattened SensorData ("+
      std::to_string(sd.data_map_size())+" entries)"
    );

    // decode & append to text
    std::map<std::string,double> numericMap;
    for (const auto &kv : sd.data_map()) {
        const auto &key  = kv.first;
        const auto &blob = kv.second;
        size_t len = blob.size();
        if (len % 4) continue;
        for (size_t i=0; i<len; i+=4) {
            uint32_t bits; memcpy(&bits,blob.data()+i,4);
            float f; memcpy(&f,&bits,4);
            double v = std::isfinite(f)?f:double(int32_t(bits));
            std::string mk = (len>4? key+"_"+std::to_string(i/4): key);
            numericMap[mk] = v;
        }
    }
    std::ofstream ofs(flattenedFilePath_, std::ios::app);
    if (ofs) {
        for (auto &p : numericMap) ofs<<p.first<<"="<<p.second<<" ";
        ofs<<"\n"; ofs.flush();
    }
}
