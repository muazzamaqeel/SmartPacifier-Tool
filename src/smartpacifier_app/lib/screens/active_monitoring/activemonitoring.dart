// File: lib/screens/1.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../generated/sensor_data.pb.dart' as protos;
import '../../generated/myservice.pbgrpc.dart' show PayloadMessage;
import '../../ipc_layer/grpc/server.dart' show myService;
import 'graphcreation.dart';

class ActiveMonitoring extends StatefulWidget {
  const ActiveMonitoring({super.key});

  @override
  State<ActiveMonitoring> createState() => _ActiveMonitoringState();
}

class _ActiveMonitoringState extends State<ActiveMonitoring> {
  late final StreamSubscription<PayloadMessage> _sub;

  /// sensorType → groupName → seriesName → list of spots
  final _buffers = <String, Map<String, Map<String, List<FlSpot>>>>{};
  int _nextX = 0;
  bool _pendingSetState = false;

  /// track which pacifier IDs are selected
  final _selectedPacifiers = <String>{};

  final _palette = <Color>[
    Colors.blue, Colors.red, Colors.green,
    Colors.orange, Colors.purple, Colors.teal,
    Colors.amber, Colors.indigo, Colors.cyan, Colors.lime,
  ];

  @override
  void initState() {
    super.initState();
    _sub = myService.onSensorData.listen(
          (pm) {
        if (!pm.hasSensorData()) return;
        _handleSensorData(pm.sensorData);
      },
      onError: (e) => debugPrint('❌ server stream error: $e'),
      onDone: ()    => debugPrint('🔒 server closed the stream'),
    );
  }

  void _handleSensorData(protos.SensorData sd) {
    final t = (_nextX++).toDouble();

    // 1) sensorType → groupName map
    final typeMap = _buffers.putIfAbsent(
      sd.sensorType,
          () => <String, Map<String, List<FlSpot>>>{},
    );

    // 2) group by pacifier (so each stream gets its own map)
    final groupName = '${sd.sensorGroup}_${sd.pacifierId}';
    final groupMap = typeMap.putIfAbsent(
      groupName,
          () => <String, List<FlSpot>>{},
    );

    // 3) decode each 4-byte or N×4 blob into one or many FlSpots
    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      if (bytes.length < 4) return;
      final bd = ByteData.sublistView(bytes);

      if (bytes.length == 4) {
        num v = bd.getFloat32(0, Endian.little);
        if (!v.isFinite) v = bd.getInt32(0, Endian.little);
        final series = groupMap.putIfAbsent(key, () => <FlSpot>[]);
        series.add(FlSpot(t, v.toDouble()));
        if (series.length > 50) series.removeAt(0);
      } else if (bytes.length % 4 == 0) {
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

    // throttle setState()
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
    // collect all pacifiers seen so far
    final pacifiers = <String>{};
    for (final typeMap in _buffers.values) {
      for (final groupName in typeMap.keys) {
        final parts = groupName.split('_');
        if (parts.isNotEmpty) pacifiers.add(parts.last);
      }
    }
    final pacifierList = pacifiers.toList()..sort();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (pacifierList.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: pacifierList.map((id) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('Pacifier $id'),
                      selected: _selectedPacifiers.contains(id),
                      onSelected: (sel) {
                        setState(() {
                          if (sel)   _selectedPacifiers.add(id);
                          else       _selectedPacifiers.remove(id);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

          // ---- graphs for each selected pacifier ----
          Expanded(
            child: _selectedPacifiers.isEmpty
                ? const Center(child: Text('Waiting for data…'))
                : ListView(
              children: [
                for (final id in _selectedPacifiers) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Text(
                      'Pacifier $id',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // buildGraphs expects sensorType→groupName→series→spots
                  Builder(builder: (_) {
                    // filter buffers down to just this pacifier
                    final filtered = <String, Map<String,
                        Map<String, List<FlSpot>>>>{};
                    _buffers.forEach((sensorType, groups) {
                      final sub = <String, Map<String, List<FlSpot>>>{};
                      groups.forEach((groupName, series) {
                        if (groupName.endsWith('_$id')) {
                          sub[groupName] = series;
                        }
                      });
                      if (sub.isNotEmpty) filtered[sensorType] = sub;
                    });
                    return filtered.isEmpty
                        ? const SizedBox()
                        : GraphCreation.buildGraphs(
                        filtered, _palette);
                  }),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
