// lib/screens/mainwindow.dart

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grpc/grpc.dart';

import '../generated/myservice.pbgrpc.dart'   show MyServiceClient, PayloadMessage;
import '../generated/google/protobuf/empty.pb.dart'   show Empty;
import '../generated/sensor_data.pb.dart'     show SensorData;

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final ClientChannel _channel;
  late final MyServiceClient _client;

  /// sensorType → groupName → seriesName → spots
  final _buffers = <String, Map<String, Map<String, List<FlSpot>>>>{};
  int _nextX = 0;
  bool _pendingSetState = false;

  final _palette = <Color>[
    Colors.blue, Colors.red, Colors.green, Colors.orange,
    Colors.purple, Colors.teal, Colors.amber, Colors.indigo,
    Colors.cyan, Colors.lime,
  ];

  @override
  void initState() {
    super.initState();

    // Pick correct host for emulator vs-desktop
    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    debugPrint('ℹ️ gRPC host=$host, port=50051');

    _channel = ClientChannel(
      host,
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _client = MyServiceClient(_channel);

    _startStreaming();
  }

  Future<void> _startStreaming() async {
    debugPrint('⏳ Connecting to gRPC stream…');
    _client.streamMessages(Empty()).listen(
          (PayloadMessage pm) {
        debugPrint('✅ got PayloadMessage @ ${DateTime.now()}');
        if (!pm.hasSensorData()) {
          debugPrint('   ⚠️ no sensorData');
          return;
        }
        final sd = pm.sensorData;
        debugPrint('   sensorType=${sd.sensorType}, keys=${sd.dataMap.keys}');
        _handleSensorData(sd);
      },
      onError: (e, st) {
        debugPrint('❌ Stream error: $e\n$st');
      },
      onDone: () {
        debugPrint('🔒 Stream closed by server');
      },
      cancelOnError: false,
    );
  }

  void _handleSensorData(SensorData sd) {
    final t = (_nextX++).toDouble();
    final typeMap = _buffers.putIfAbsent(sd.sensorType, () => {});

    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List
          ? raw
          : Uint8List.fromList(raw);
      if (bytes.length != 4) return;

      final bd = ByteData.sublistView(bytes);
      num v = bd.getFloat32(0, Endian.little);
      if (v.isNaN) v = bd.getInt32(0, Endian.little);

      final parts = key.split('_');
      final group = parts.first;       // e.g. "gyro"
      final seriesName = key;          // full key

      final groupMap = typeMap.putIfAbsent(group, () => {});
      final series = groupMap.putIfAbsent(seriesName, () => <FlSpot>[]);
      series.add(FlSpot(t, v.toDouble()));
      if (series.length > 50) series.removeAt(0);
    });

    if (!_pendingSetState) {
      _pendingSetState = true;
      Future.microtask(() {
        if (mounted) setState(() {});
        _pendingSetState = false;
      });
    }
  }

  @override
  void dispose() {
    _channel.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final types = _buffers.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Active Monitoring')),
      body: types.isEmpty
          ? const Center(child: Text('Waiting for data…'))
          : ListView.builder(
        itemCount: types.length,
        itemBuilder: (ctx, idx) {
          final type = types[idx];
          final groups = _buffers[type]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              // One chart per group (e.g. "gyro", "mags", "accs")
              ...groups.entries.map((entry) {
                return _buildGroupChart(entry.key, entry.value);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupChart(
      String groupName,
      Map<String, List<FlSpot>> seriesMap,
      ) {
    final bars = <LineChartBarData>[];
    int colorIdx = 0;
    for (final seriesName in seriesMap.keys) {
      bars.add(LineChartBarData(
        spots: seriesMap[seriesName]!,
        isCurved: true,
        dotData: FlDotData(show: false),
        color: _palette[colorIdx % _palette.length],
        barWidth: 2,
      ));
      colorIdx++;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    lineBarsData: bars,
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
