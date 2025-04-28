// lib/screens/mainwindow.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../ipc_layer/grpc/gprc_client.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final List<String> _logs = [];
  final ScrollController _scroll = ScrollController();
  late final MyGrpcClient _client;

  @override
  void initState() {
    super.initState();
    _client = MyGrpcClient();
    _startStreaming();
  }

  Future<void> _startStreaming() async {
    await _client.init();
    _client.streamSensorData().listen(
          (sd) {
        _logs.add('── pacifier=${sd.pacifierId}  type=${sd.sensorType} ──');

        if (sd.dataMap.isEmpty) {
          _logs.add('  (no data)');
        } else {
          sd.dataMap.forEach((key, raw) {
            final bytes = raw as Uint8List;
            _logs.add('• $key: ${bytes.length} bytes');

            if (bytes.length == 4) {
              final bd = ByteData.sublistView(bytes);
              // Interpret both as float32 and int32:
              final f = bd.getFloat32(0, Endian.little);
              final i = bd.getInt32(0, Endian.little);
              _logs.add('    float32 = ${f.toStringAsFixed(3)}, int32 = $i');
            } else {
              // For non-4-byte payloads then we use hex:
              _logs.add('    raw: ${bytes.map((b) => b.toRadixString(16).padLeft(2, "0")).join(" ")}');
            }
          });
        }

        setState(() {});
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      },
      onError: (e) => setState(() => _logs.add('🔴 Stream error: $e')),
    );
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
