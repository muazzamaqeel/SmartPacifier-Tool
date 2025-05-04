#include "communication_layer/CommunicationLayer.h"

#include <broker/Logger.h>
#include <broker/BrokerCheck.h>

#ifdef GetMessage
# undef GetMessage
#endif

#include <google/protobuf/dynamic_message.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/message.h>

#include <sensor_data.pb.h>
#include <cstring>

CommunicationLayer::CommunicationLayer()
  : running_(false),
    dataRetrieval_(std::make_shared<DataRetrieval>(
      "tcp://localhost:1883",
      "DataRetrievalClient",
      "Pacifier/#"))
{}

CommunicationLayer::~CommunicationLayer() {
  stopCommunicationServices();
  if (mqttThread_.joinable())
    mqttThread_.join();
}

void CommunicationLayer::startCommunicationServices() {
  if (!BrokerCheck::isMosquittoRunning()) {
    Logger::getInstance().log("Please start Mosquitto broker first.");
    return;
  }
  Logger::getInstance().log("Mosquitto running.");

  grpcClient_.init("127.0.0.1", 50051);

  dataRetrieval_->setMessageCallback([this](const std::string &raw) {
    Protos::SensorData sd;
    if (!sd.ParseFromString(raw)) {
      Logger::getInstance().log("❌ invalid SensorData");
      return;
    }

    // If already flattened (multiple entries), just forward
    if (sd.data_map_size() != 1) {
      grpcClient_.send(sd);
      Logger::getInstance().log("▶ forwarded pre-flattened SensorData with " +
                                std::to_string(sd.data_map_size()) + " entries");
      return;
    }

    // Determine the nested message type from sensor_type
    std::string typeName;
    auto st = sd.sensor_type();
    if (!st.empty()) {
      st[0] = static_cast<char>(toupper(st[0]));
      typeName = "Protos." + st + "Data";
    } else {
      Logger::getInstance().log("❌ missing sensor_type");
      return;
    }

    // Extract the single nested blob
    const std::string nested = sd.data_map().begin()->second;
    sd.mutable_data_map()->clear();

    // Look up its descriptor dynamically
    const auto* desc = google::protobuf::DescriptorPool::generated_pool()
      ->FindMessageTypeByName(typeName);
    if (!desc) {
      Logger::getInstance().log("❌ unknown payload type: " + typeName);
      return;
    }

    // Parse nested message
    google::protobuf::DynamicMessageFactory factory;
    std::unique_ptr<google::protobuf::Message> msg(
      factory.GetPrototype(desc)->New());
    if (!msg->ParseFromString(nested)) {
      Logger::getInstance().log("❌ failed to parse nested " + typeName);
      return;
    }

    const auto* refl = msg->GetReflection();

    auto pack32 = [](uint32_t w) {
      char buf[4];
      std::memcpy(buf, &w, 4);
      return std::string(buf, 4);
    };

    // Flatten all fields into data_map
    for (int f = 0; f < desc->field_count(); ++f) {
      const auto* field = desc->field(f);

      if (field->is_repeated()) {
        int N = refl->FieldSize(*msg, field);
        for (int i = 0; i < N; ++i) {
          std::string key = field->name() + "_" + std::to_string(i);
          switch (field->cpp_type()) {
            case google::protobuf::FieldDescriptor::CPPTYPE_FLOAT: {
              float v = refl->GetRepeatedFloat(*msg, field, i);
              uint32_t bits;
              std::memcpy(&bits, &v, 4);
              (*sd.mutable_data_map())[key] = pack32(bits);
              break;
            }
            case google::protobuf::FieldDescriptor::CPPTYPE_INT32: {
              int32_t v = refl->GetRepeatedInt32(*msg, field, i);
              (*sd.mutable_data_map())[key] = pack32(static_cast<uint32_t>(v));
              break;
            }
            default:
              break;
          }
        }
      }
      else if (refl->HasField(*msg, field)) {
        std::string key = field->name();
        switch (field->cpp_type()) {
          case google::protobuf::FieldDescriptor::CPPTYPE_FLOAT: {
            float v = refl->GetFloat(*msg, field);
            uint32_t bits;
            std::memcpy(&bits, &v, 4);
            (*sd.mutable_data_map())[key] = pack32(bits);
            break;
          }
          case google::protobuf::FieldDescriptor::CPPTYPE_INT32: {
            int32_t v = refl->GetInt32(*msg, field);
            (*sd.mutable_data_map())[key] = pack32(static_cast<uint32_t>(v));
            break;
          }
          default:
            break;
        }
      }
    }

    grpcClient_.send(sd);
    Logger::getInstance().log("✅ sent " + typeName + " with " +
                              std::to_string(sd.data_map_size()) +
                              " flattened entries");
  });

  running_ = true;
  mqttThread_ = std::thread(&CommunicationLayer::runMqttClient, this);
}

void CommunicationLayer::stopCommunicationServices() {
  running_ = false;
  dataRetrieval_->stop();
}

void CommunicationLayer::runMqttClient() {
  Logger::getInstance().log("Starting MQTT loop…");
  try {
    dataRetrieval_->start();
    Logger::getInstance().log("MQTT stopped.");
  }
  catch (const std::exception &e) {
    Logger::getInstance().log(std::string("MQTT exception: ") + e.what());
  }
}