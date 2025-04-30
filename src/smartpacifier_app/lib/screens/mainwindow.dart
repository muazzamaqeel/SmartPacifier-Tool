// lib/screens/mainwindow.dart

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grpc/grpc.dart';

import '../ipc_layer/grpc/deserialization.dart';
import '../generated/myservice.pbgrpc.dart' show MyServiceClient, PayloadMessage;
import '../generated/google/protobuf/empty.pb.dart'   show Empty;
import '../generated/sensor_data.pb.dart'             show SensorData, IMUData, PPGData;

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final ClientChannel _channel;
  late final MyServiceClient _client;

  /// sensorType → (seriesName → spots)
  final Map<String, Map<String, List<FlSpot>>> _buffers = {};
  int _nextX = 0;
  bool _pendingSetState = false;

  final List<Color> _palette = [
    Colors.blue, Colors.red, Colors.green, Colors.orange,
    Colors.purple, Colors.teal, Colors.amber, Colors.indigo,
    Colors.cyan, Colors.lime,
  ];

  @override
  void initState() {
    super.initState();

    // 1) pick correct host
    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    debugPrint('ℹ️ Starting gRPC client, host=$host, port=50051');

    // 2) build channel & stub
    _channel = ClientChannel(
      host,
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _client = MyServiceClient(_channel);

    // 3) start streaming
    _startStreaming();
  }

  Future<void> _startStreaming() async {
    debugPrint('⏳ Connecting to gRPC…');
    // No timeout on the stream call, so it stays open:
    _client.streamMessages(Empty()).listen(
          (PayloadMessage pm) {
        debugPrint('✅ got PayloadMessage @ ${DateTime.now()}');
        if (!pm.hasSensorData()) return;

        final sd = pm.sensorData;
        debugPrint('    sensorType=${sd.sensorType}, keys=${sd.dataMap.keys}');
        _onSensorData(sd);
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

  void _onSensorData(SensorData sd) {
    final t = (_nextX++).toDouble();
    final outerMap = _buffers.putIfAbsent(sd.sensorType, () => <String, List<FlSpot>>{});

    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      if (bytes.length == 4) {
        _decodeScalar(outerMap, key, bytes, t);
      } else if (_tryImu(bytes, outerMap, t)) {
        // handled
      } else if (_tryPpg(bytes, outerMap, t)) {
        // handled
      }
    });

    if (!_pendingSetState) {
      _pendingSetState = true;
      Future.microtask(() {
        if (mounted) setState(() {});
        _pendingSetState = false;
      });
    }
  }

  void _decodeScalar(
      Map<String, List<FlSpot>> buf,
      String field,
      Uint8List bytes,
      double t,
      ) {
    final bd = ByteData.sublistView(bytes);
    num v = bd.getFloat32(0, Endian.little);
    if (v.isNaN) v = bd.getInt32(0, Endian.little);
    _addSpot(buf, field, t, v.toDouble());
  }

  bool _tryImu(
      Uint8List b,
      Map<String, List<FlSpot>> buf,
      double t,
      ) {
    try {
      final imu = IMUData.fromBuffer(b);
      for (var g in imu.gyros) {
        _addSpot(buf, 'gyro_x', t, g.gyroX);
        _addSpot(buf, 'gyro_y', t, g.gyroY);
        _addSpot(buf, 'gyro_z', t, g.gyroZ);
      }
      for (var m in imu.mags) {
        _addSpot(buf, 'mag_x', t, m.magX);
        _addSpot(buf, 'mag_y', t, m.magY);
        _addSpot(buf, 'mag_z', t, m.magZ);
      }
      for (var a in imu.accs) {
        _addSpot(buf, 'acc_x', t, a.accX);
        _addSpot(buf, 'acc_y', t, a.accY);
        _addSpot(buf, 'acc_z', t, a.accZ);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _tryPpg(
      Uint8List b,
      Map<String, List<FlSpot>> buf,
      double t,
      ) {
    try {
      final ppg = PPGData.fromBuffer(b);
      for (var led in ppg.leds) {
        _addSpot(buf, 'led_1', t, led.led1.toDouble());
        _addSpot(buf, 'led_2', t, led.led2.toDouble());
        _addSpot(buf, 'led_3', t, led.led3.toDouble());
      }
      for (var tmp in ppg.temperatures) {
        _addSpot(buf, 'temperature_1', t, tmp.temperature1);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  void _addSpot(
      Map<String, List<FlSpot>> buf,
      String field,
      double x,
      double y,
      ) {
    final series = buf.putIfAbsent(field, () => <FlSpot>[]);
    series.add(FlSpot(x, y));
    if (series.length > 50) series.removeAt(0);
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
      backgroundColor: Colors.black12,
      appBar: AppBar(title: const Text('Active Monitoring')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: types.isEmpty
            ? const Center(child: Text('Waiting for data…'))
            : ListView(
          children: types.map((outer) {
            final fields = _buffers[outer]!.keys.toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  outer,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                ...fields.asMap().entries.map((e) {
                  final field = e.value;
                  final color = _palette[e.key % _palette.length];
                  final spots = _buffers[outer]![field]!;
                  return _buildChart(field, spots, color);
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildChart(String field, List<FlSpot> spots, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 200,
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    color: color,
                    barWidth: 2,
                  ),
                ],
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Workaround for fl_chart up through 0.6.0 calling
/// MediaQuery.boldTextOverride (removed in Flutter 3.7+).
extension MediaQueryPatch on MediaQuery {
  static bool get boldTextOverride => false;
}
