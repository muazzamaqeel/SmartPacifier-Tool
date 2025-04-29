import 'dart:typed_data';
import '../../generated/sensor_data.pb.dart';

/// Turn every entry in SensorData.dataMap into TWO values:
///  • a float32 (if it was a 4-byte little-endian float)
///  • an int32   (if it was a 4-byte little-endian signed int)
///
/// This sidesteps all mergeFromBuffer errors.
class DataDeserializer {
  /// Returns a map where each original key K produces:
  ///   "K_float" → float32
  ///   "K_int"   →  int32
  static Map<String, num> parsePayload(SensorData sd) {
    final out = <String, num>{};

    sd.dataMap.forEach((key, raw) {
      final bytes = raw as Uint8List;
      if (bytes.length == 4) {
        final bd = ByteData.sublistView(bytes);
        final f = bd.getFloat32(0, Endian.little);
        final i = bd.getInt32(0, Endian.little);
        out['${key}_float'] = f;
        out['${key}_int']   = i;
      }
      // you can add else‐branch here if you ever store >4 byte blobs
    });

    return out;
  }
}
