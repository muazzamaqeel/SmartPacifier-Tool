import 'dart:typed_data';
import '../../generated/sensor_data.pb.dart' as protos;

/// Given a fully-flattened SensorData.dataMap, decode every 4-byte entry
/// into a num (float if finite, otherwise int), and automatically handle
/// any repeated/unnamed indices by appending “_0”, “_1”, etc.
class DataDeserializer {
  static Map<String, num> parsePayload(protos.SensorData sd) {
    final out = <String, num>{};
    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      final bd = ByteData.sublistView(bytes);

      // If exactly 4 bytes: single scalar
      if (bytes.length == 4) {
        final f = bd.getFloat32(0, Endian.little);
        out[key] = f.isFinite ? f : bd.getInt32(0, Endian.little);
      }
      // If N×4 bytes: N‐length array of scalars
      else if (bytes.length % 4 == 0) {
        final count = bytes.length ~/ 4;
        for (var i = 0; i < count; i++) {
          final f = bd.getFloat32(4 * i, Endian.little);
          final v = f.isFinite ? f : bd.getInt32(4 * i, Endian.little);
          out['${key}_$i'] = v.toDouble();
        }
      }
      // else skip non-aligned blobs
    });
    return out;
  }
}
