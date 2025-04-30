// lib/ipc_layer/grpc/deserialization.dart
import 'dart:typed_data';
import 'package:protobuf/protobuf.dart';
import '../../generated/sensor_data.pb.dart';

/// Turns every 4-byte entry in SensorData.dataMap into a numeric value
/// (float32 or int32), with no hard-coded names.
class DataDeserializer {
  /// Reads the raw bytes as either int32 or float32.
  /// Returns a map from the exact key in dataMap to its numeric value.
  static Map<String, num> parsePayload(SensorData sd) {
    final out = <String, num>{};
    sd.dataMap.forEach((String key, List<int> raw) {
      if (raw.length == 4) {
        final bd = ByteData.sublistView(Uint8List.fromList(raw));
        // decide signed vs float based on: can we parse it as a float?
        // (you could instead carry a schema somewhere to decide)
        // here we assume: if the raw bytes interpreted as float is NaN or ±∞,
        // fall back to int.
        final f = bd.getFloat32(0, Endian.little);
        if (f.isFinite) {
          out[key] = f;
        } else {
          out[key] = bd.getInt32(0, Endian.little);
        }
      }
    });
    return out;
  }
}
