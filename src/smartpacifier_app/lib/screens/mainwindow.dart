import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../ipc_layer/grpc/gprc_client.dart';
import '../ipc_layer/grpc/deserialization.dart';
import '../../generated/sensor_data.pb.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final MyGrpcClient _client;
  StreamSubscription<SensorData>? _sub;

  // dynamic storage: each key → a sliding List<FlSpot>
  final Map<String, List<FlSpot>> _series = {};
  int _t = 0;

  @override
  void initState() {
    super.initState();
    _client = MyGrpcClient();
    _start();
  }

  Future<void> _start() async {
    await _client.init();
    _sub = _client.streamSensorData().listen((sd) {
      final data = DataDeserializer.parsePayload(sd);
      setState(() {
        final t = (_t++).toDouble();
        data.forEach((k, v) {
          final list = _series.putIfAbsent(k, () => <FlSpot>[]);
          list.add(FlSpot(t, v.toDouble()));
          if (list.length > 50) list.removeAt(0);
        });
      });
    }, onError: (e) {
      debugPrint('Stream error: $e');
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _client.shutdown();
    super.dispose();
  }

  Widget _buildChart(String title, List<FlSpot> spots) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: LineChart(LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
              )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charts = _series.keys
        .map((k) => _buildChart(k.toUpperCase(), _series[k]!))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Active Monitoring')),
      body: SingleChildScrollView(child: Column(children: charts)),
    );
  }
}
