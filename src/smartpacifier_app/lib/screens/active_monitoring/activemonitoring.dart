// File: lib/screens/active_monitoring/activemonitoring.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../generated/myservice.pbgrpc.dart' show PayloadMessage;
import '../../generated/sensor_data.pb.dart' as protos;
import '../../client_layer/connector.dart';
import 'graphcreation.dart';

class ActiveMonitoring extends StatefulWidget {
  /// The backend whose data this view shows.
  final String backend;
  const ActiveMonitoring({Key? key, required this.backend}) : super(key: key);

  @override
  State<ActiveMonitoring> createState() => _ActiveMonitoringState();
}

class _ActiveMonitoringState extends State<ActiveMonitoring> {
  late StreamSubscription<PayloadMessage> _sub;

  /// sensorType → groupName → seriesName → list of spots
  final _buffers = <String, Map<String, Map<String, List<FlSpot>>>>{};
  int _nextX = 0;
  bool _pendingSetState = false;

  /// which pacifier IDs are toggled on
  final _selectedPacifiers = <String>{};

  /// a fixed palette of line‐colors
  final _palette = <Color>[
    Colors.blue, Colors.red, Colors.green,
    Colors.orange, Colors.purple, Colors.teal,
    Colors.amber, Colors.indigo, Colors.cyan, Colors.lime,
  ];

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant ActiveMonitoring old) {
    super.didUpdateWidget(old);
    if (old.backend != widget.backend) {
      _sub.cancel();
      _buffers.clear();
      _selectedPacifiers.clear();
      _nextX = 0;
      _subscribe();
    }
  }

  void _subscribe() {
    // listen *only* to the selected backend’s stream:
    _sub = Connector()
        .dataStreamFor(widget.backend)
        .listen(
          (pm) {
        if (!pm.hasSensorData()) return;
        _handleSensorData(pm.sensorData);
      },
      onError: (e) {
        debugPrint('❌ stream error for ${widget.backend}: $e');
      },
      onDone: () {
        debugPrint('🔒 stream closed for ${widget.backend}');
      },
    );
  }

  void _handleSensorData(protos.SensorData sd) {
    final t = (_nextX++).toDouble();

    // 1) sensorType → groupName map
    final typeMap = _buffers.putIfAbsent(
      sd.sensorType,
          () => <String, Map<String, List<FlSpot>>>{},
    );

    // 2) group by pacifier
    final groupName = '${sd.sensorGroup}_${sd.pacifierId}';
    final groupMap = typeMap.putIfAbsent(
      groupName,
          () => <String, List<FlSpot>>{},
    );

    // 3) decode each blob into FlSpots
    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      if (bytes.length < 4) {
        return;
      }
      final bd = ByteData.sublistView(bytes);

      if (bytes.length == 4) {
        num v = bd.getFloat32(0, Endian.little);
        if (!v.isFinite) {
          v = bd.getInt32(0, Endian.little);
        }
        final series = groupMap.putIfAbsent(key, () => <FlSpot>[]);
        series.add(FlSpot(t, v.toDouble()));
        if (series.length > 50) {
          series.removeAt(0);
        }
      } else if (bytes.length % 4 == 0) {
        final count = bytes.length ~/ 4;
        for (var i = 0; i < count; i++) {
          num v = bd.getFloat32(i * 4, Endian.little);
          if (!v.isFinite) {
            v = bd.getInt32(i * 4, Endian.little);
          }
          final seriesName = '$key[$i]';
          final series = groupMap.putIfAbsent(seriesName, () => <FlSpot>[]);
          series.add(FlSpot(t, v.toDouble()));
          if (series.length > 50) {
            series.removeAt(0);
          }
        }
      }
    });

    // throttle rebuilds
    if (!_pendingSetState) {
      _pendingSetState = true;
      Future.microtask(() {
        if (mounted) {
          setState(() {});
        }
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
    // collect all pacifier IDs seen so far
    final pacifiers = <String>{};
    for (final typeMap in _buffers.values) {
      for (final groupName in typeMap.keys) {
        final parts = groupName.split('_');
        if (parts.isNotEmpty) {
          pacifiers.add(parts.last);
        }
      }
    }
    final pacifierList = pacifiers.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Monitoring — ${widget.backend}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // chips to toggle pacifiers
          if (pacifierList.isNotEmpty) ...[
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
                          if (sel) {
                            _selectedPacifiers.add(id);
                          } else {
                            _selectedPacifiers.remove(id);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // graphs for each selected pacifier
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

                  // buildGraphs expects:
                  // Map<sensorType, Map<groupName, Map<seriesName, List<FlSpot>>>>
                  Builder(builder: (_) {
                    final filtered =
                    <String, Map<String, Map<String, List<FlSpot>>>>{};
                    _buffers.forEach((stype, groups) {
                      final sub = <String, Map<String, List<FlSpot>>>{};
                      groups.forEach((gname, series) {
                        if (gname.endsWith('_$id')) {
                          sub[gname] = series;
                        }
                      });
                      if (sub.isNotEmpty) {
                        filtered[stype] = sub;
                      }
                    });
                    if (filtered.isEmpty) {
                      return const SizedBox();
                    }
                    return GraphCreation.buildGraphs(
                      filtered,
                      _palette,
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
