import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../generated/sensor_data.pb.dart' as protos;
import '../generated/myservice.pbgrpc.dart' show PayloadMessage;
import '../ipc_layer/grpc/server.dart' show myService;
import 'graphcreation.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final StreamSubscription<PayloadMessage> _sub;

  /// sensorType → groupName → seriesName → list of spots
  final _buffers = <String, Map<String, Map<String, List<FlSpot>>>>{};
  int _nextX = 0;
  bool _pendingSetState = false;

  final _palette = <Color>[
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
    Colors.lime,
  ];

  @override
  void initState() {
    super.initState();
    _sub = myService.onSensorData.listen(
          (pm) {
        if (!pm.hasSensorData()) return;
        _handleSensorData(pm.sensorData);
      },
      onError: (e) => debugPrint('❌ server stream error: \$e'),
      onDone: () => debugPrint('🔒 server closed the stream'),
    );
  }

  void _handleSensorData(protos.SensorData sd) {
    final t = (_nextX++).toDouble();

    // 1) group by sensorType
    final typeMap = _buffers.putIfAbsent(
      sd.sensorType,
          () => <String, Map<String, List<FlSpot>>>{},
    );

    // 2) group by pacifier (so each stream gets its own card)
    final groupName = '${sd.sensorGroup}_${sd.pacifierId}';
    final groupMap = typeMap.putIfAbsent(
      groupName,
          () => <String, List<FlSpot>>{},
    );

    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      if (bytes.length < 4) return;
      final bd = ByteData.sublistView(bytes);

      // single‐value
      if (bytes.length == 4) {
        num v = bd.getFloat32(0, Endian.little);
        if (!v.isFinite) v = bd.getInt32(0, Endian.little);
        final series = groupMap.putIfAbsent(key, () => <FlSpot>[]);
        series.add(FlSpot(t, v.toDouble()));
        if (series.length > 50) series.removeAt(0);
      }
      // multi‐value (N floats/ints in one blob)
      else if (bytes.length % 4 == 0) {
        final count = bytes.length ~/ 4;
        for (var i = 0; i < count; i++) {
          num v = bd.getFloat32(i * 4, Endian.little);
          if (!v.isFinite) v = bd.getInt32(i * 4, Endian.little);
          final seriesName = '$key\[$i\]';
          final series = groupMap.putIfAbsent(seriesName, () => <FlSpot>[]);
          series.add(FlSpot(t, v.toDouble()));
          if (series.length > 50) series.removeAt(0);
        }
      }
    });

    // throttle rebuilds
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
    final sensorTypes = _buffers.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Active Monitoring')),
      body: sensorTypes.isEmpty
          ? const Center(child: Text('Waiting for data…'))
          : GraphCreation.buildGraphs(_buffers, _palette),
    );
  }
}
