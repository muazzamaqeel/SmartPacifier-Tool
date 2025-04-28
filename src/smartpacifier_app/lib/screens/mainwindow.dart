// lib/screens/mainwindow.dart

import 'package:flutter/material.dart';
import '../ipc_layer/grpc/gprc_client.dart';
import '../generated/sensor_data.pb.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final List<String> _logs = [];
  final _scroll = ScrollController();
  late final MyGrpcClient _client;

  @override
  void initState() {
    super.initState();
    _client = MyGrpcClient();
    _startStreaming();
  }

  Future<void> _startStreaming() async {
    try {
      await _client.init();
      _client.streamSensorData().listen((sd) {
        final lines = _formatSensorData(sd);
        setState(() => _logs.addAll(lines));
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }, onError: (e) {
        setState(() => _logs.add('🔴 Stream error: $e'));
      });
    } catch (e) {
      setState(() => _logs.add('🔴 Initialization error: $e'));
    }
  }

  /// Unpacks *every* entry in dataMap, but safely.
  List<String> _formatSensorData(SensorData sd) {
    final out = <String>[];
    out.add('── Pacifier=${sd.pacifierId}  type=${sd.sensorType}  group=${sd.sensorGroup} ──');

    if (sd.dataMap.isEmpty) {
      out.add('  ⚠️ dataMap is empty');
      return out;
    }

    // Show which keys & how many bytes arrived
    sd.dataMap.forEach((key, bytes) {
      out.add('• key="$key", bytes=${bytes.length}');

      // Now attempt to parse that blob
      if (sd.sensorType.toLowerCase() == 'imu') {
        try {
          final imu = IMUData.fromBuffer(bytes);
          for (var i = 0; i < imu.accs.length; i++) {
            final a = imu.accs[i];
            out.add('    acc[$i]: x=${a.accX}, y=${a.accY}, z=${a.accZ}');
          }
          for (var i = 0; i < imu.gyros.length; i++) {
            final g = imu.gyros[i];
            out.add('    gyro[$i]: x=${g.gyroX}, y=${g.gyroY}, z=${g.gyroZ}');
          }
          for (var i = 0; i < imu.mags.length; i++) {
            final m = imu.mags[i];
            out.add('    mag[$i]: x=${m.magX}, y=${m.magY}, z=${m.magZ}');
          }
        } catch (e) {
          out.add('    ❌ IMUData.parse failed: $e');
        }
      }
      else if (sd.sensorType.toLowerCase() == 'ppg') {
        try {
          final ppg = PPGData.fromBuffer(bytes);
          for (var i = 0; i < ppg.leds.length; i++) {
            final l = ppg.leds[i];
            out.add('    led[$i]: ${l.led1}, ${l.led2}, ${l.led3}');
          }
          for (var i = 0; i < ppg.temperatures.length; i++) {
            final t = ppg.temperatures[i];
            out.add('    temp[$i]: ${t.temperature1}');
          }
        } catch (e) {
          out.add('    ❌ PPGData.parse failed: $e');
        }
      }
      else {
        out.add('    ⚠️ Unknown sensorType="${sd.sensorType}", skipping parse');
      }
    });

    return out;
  }

  @override
  void dispose() {
    _client.shutdown();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Active Monitoring')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          controller: _scroll,
          itemCount: _logs.length,
          itemBuilder: (_, i) => Text(
            _logs[i],
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
