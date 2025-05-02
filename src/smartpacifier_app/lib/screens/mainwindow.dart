import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../generated/sensor_data.pb.dart' as protos;
import '../generated/myservice.pbgrpc.dart' show PayloadMessage;
import '../ipc_layer/grpc/server.dart' show myService;

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final StreamSubscription<PayloadMessage> _sub;

  /// sensorType → groupName → seriesName → spots
  final _buffers = <String, Map<String, Map<String, List<FlSpot>>>>{};
  int _nextX = 0;
  bool _pendingSetState = false;

  final _palette = <Color>[
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    // …
  ];

  @override
  void initState() {
    super.initState();
    _sub = myService.onSensorData.listen(
          (pm) {
        if (!pm.hasSensorData()) return;
        final protos.SensorData sd = pm.sensorData;
        _handleSensorData(sd);
      },
      onError: (e) => debugPrint('❌ server stream error: $e'),
      onDone: () => debugPrint('🔒 server closed the stream'),
    );
  }

  void _handleSensorData(protos.SensorData sd) {
    final t = (_nextX++).toDouble();
    final typeMap = _buffers.putIfAbsent(sd.sensorType, () => {});

    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      if (bytes.length != 4) return;

      final bd = ByteData.sublistView(bytes);
      num v = bd.getFloat32(0, Endian.little);
      if (v.isNaN || v.isInfinite) v = bd.getInt32(0, Endian.little);

      final group = key.split('_').first;
      final series = typeMap
          .putIfAbsent(group, () => <String, List<FlSpot>>{})
          .putIfAbsent(key, () => <FlSpot>[]);
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
    _sub.cancel();
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
                child: Text(type,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              for (final entry in groups.entries)
                _buildGroupChart(entry.key, entry.value),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupChart(
      String groupName, Map<String, List<FlSpot>> seriesMap) {
    final bars = <LineChartBarData>[];
    var colorIdx = 0;
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
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(groupName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: LineChart(LineChartData(
                  lineBarsData: bars,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
