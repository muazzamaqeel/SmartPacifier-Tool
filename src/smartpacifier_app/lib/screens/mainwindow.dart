// lib/screens/mainwindow.dart

import 'dart:convert';
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
    _client.streamSensorData().listen(
          (sd) {
        // 1) Zero-arg writeToJson():
        final jsonString = sd.writeToJson();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

        // 2) Pretty-print if you like:
        final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonMap);

        setState(() {
          _logs.add('── pacifier=${sd.pacifierId} type=${sd.sensorType} ──');
          _logs.addAll(prettyJson.split('\n'));
        });

        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      },
      onError: (e) {
        setState(() => _logs.add('🔴 Stream error: $e'));
      },
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
