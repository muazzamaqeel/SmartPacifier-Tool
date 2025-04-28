// lib/screens/mainwindow.dart

import 'dart:typed_data';
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
    await _client.init();
    _client.streamSensorData().listen((sd) {
      final lines = _formatSensorData(sd);
      setState(() => _logs.addAll(lines));
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    }, onError: (e) {
      setState(() => _logs.add('🔴 Stream error: $e'));
    });
  }

  List<String> _formatSensorData(SensorData sd) {
    final out = <String>[];

    out.add('── Pacifier=${sd.pacifierId}  type=${sd.sensorType}  group=${sd.sensorGroup} ──');
    if (sd.dataMap.isEmpty) {
      out.add('  ⚠️ dataMap empty');
      return out;
    }

    sd.dataMap.forEach((key, bytes) {
      out.add('• key="$key", bytes=${bytes.length}');

      final bd = ByteData.sublistView(bytes as TypedData);

      if (sd.sensorType.toLowerCase() == 'imu') {
        // C++ is apparently writing *single* floats per key:
        if (key.startsWith('acc_')) {
          final v = bd.getFloat32(0, Endian.little);
          out.add('    acc ${key.substring(4)} = $v');
        } else if (key.startsWith('gyro_')) {
          final v = bd.getFloat32(0, Endian.little);
          out.add('    gyro ${key.substring(5)} = $v');
        } else if (key.startsWith('mag_')) {
          final v = bd.getFloat32(0, Endian.little);
          out.add('    mag ${key.substring(4)} = $v');
        } else {
          out.add('    ⚠️ Unknown IMU key "$key"');
        }
      }
      else if (sd.sensorType.toLowerCase() == 'ppg') {
        // C++ is writing 4-byte ints for LED and 4-byte floats for temperature:
        if (key.startsWith('led_')) {
          final v = bd.getInt32(0, Endian.little);
          out.add('    led ${key.substring(4)} = $v');
        } else if (key == 'temperature') {
          final v = bd.getFloat32(0, Endian.little);
          out.add('    temperature = $v');
        } else {
          out.add('    ⚠️ Unknown PPG key "$key"');
        }
      }
      else {
        out.add('    ⚠️ Unsupported sensorType="${sd.sensorType}"');
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
