// lib/screens/active_monitoring/activemonitoring.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../client_layer/connector.dart';
import '../../generated/sensor_data.pb.dart' as protos;
import '../../generated/myservice.pbgrpc.dart' show PayloadMessage;
import 'graphcreation.dart';

class ActiveMonitoring extends StatefulWidget {
  final String backend;
  const ActiveMonitoring({super.key, required this.backend});

  @override
  State<ActiveMonitoring> createState() => _ActiveMonitoringState();
}

class _ActiveMonitoringState extends State<ActiveMonitoring>
    with SingleTickerProviderStateMixin {
  StreamSubscription<PayloadMessage>? _sub;

  /// sensorType → groupName → seriesName → list of spots
  final Map<String, Map<String, Map<String, List<FlSpot>>>> _buffers = {};

  /// which pacifier IDs are checked
  final Set<String> _selectedPacifiers = {};

  /// in-app log lines
  final List<String> _logs = [];

  late final TabController _tabController;
  int _nextX = 0;
  bool _pendingSetState = false;

  static const int _maxLogs = 200;

  final List<Color> _palette = [
    Colors.blue, Colors.red, Colors.green,
    Colors.orange, Colors.purple, Colors.teal,
    Colors.amber, Colors.indigo, Colors.cyan, Colors.lime,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant ActiveMonitoring old) {
    super.didUpdateWidget(old);
    if (old.backend != widget.backend) {
      _sub?.cancel();
      _buffers.clear();
      _logs.clear();
      _selectedPacifiers.clear();
      _subscribe();
    }
  }

  void _subscribe() {
    _sub = Connector().dataStreamFor(widget.backend).listen((pm) {
      _handleSensorData(pm.sensorData);

      final ts = DateTime.now().toIso8601String();
      setState(() {
        _logs.add('[$ts] Received from ${widget.backend}: '
            'pacifierId=${pm.sensorData.pacifierId}');
        if (_logs.length > _maxLogs) _logs.removeAt(0);
      });
    }, onError: (e) {
      final ts = DateTime.now().toIso8601String();
      setState(() {
        _logs.add('[$ts] Stream error from ${widget.backend}: $e');
        if (_logs.length > _maxLogs) _logs.removeAt(0);
      });
    });
  }

  void _handleSensorData(protos.SensorData sd) {
    final t = (_nextX++).toDouble();

    // 1) sensorType → groupName map
    final typeMap = _buffers.putIfAbsent(sd.sensorType, () => {});

    // 2) groupName key
    final groupName = '${sd.sensorGroup}_${sd.pacifierId}';
    final groupMap = typeMap.putIfAbsent(groupName, () => {});

    // 3) decode into FlSpots
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
          final name = '$key[$i]';
          final series = groupMap.putIfAbsent(name, () => <FlSpot>[]);
          series.add(FlSpot(t, v.toDouble()));
          if (series.length > 50) series.removeAt(0);
        }
      }
    });

    // throttle setState so we don’t rebuild on every spot
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
    _sub?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a sorted list of all pacifier IDs we’ve seen
    final pacifierIds = <String>{};
    for (final groups in _buffers.values) {
      for (final groupName in groups.keys) {
        final parts = groupName.split('_');
        if (parts.isNotEmpty) pacifierIds.add(parts.last);
      }
    }
    pacifierIds.removeWhere((id) => id.isEmpty);
    final pacifierList = pacifierIds.toList()
      ..sort((a, b) =>
          (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Monitoring — ${widget.backend}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Graphs'),
            Tab(text: 'Logs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ─── GRAPHS TAB ───────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter chips
              if (pacifierList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                ),

              // Graph area
              Expanded(
                child: _selectedPacifiers.isEmpty
                    ? const Center(
                  child: Text(
                    '❗️ No pacifier selected — check a chip above to see its graphs',
                  ),
                )
                    : ListView(
                  children: _selectedPacifiers.map((id) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            'Pacifier $id',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Build only this pacifier’s graphs
                        Builder(builder: (_) {
                          // filtered: sensorType → groupName → seriesMap
                          final filtered = <String,
                              Map<String, Map<String, List<FlSpot>>>>{};
                          _buffers.forEach((sensorType, groups) {
                            final subGroups =
                            <String, Map<String, List<FlSpot>>>{};
                            groups.forEach((groupName, seriesMap) {
                              if (groupName.endsWith('_$id')) {
                                subGroups[groupName] = seriesMap;
                              }
                            });
                            if (subGroups.isNotEmpty) {
                              filtered[sensorType] = subGroups;
                            }
                          });

                          if (filtered.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return GraphCreation.buildGraphs(
                              filtered, _palette);
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // ─── LOGS TAB ────────────────────────
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _logs.length,
            itemBuilder: (_, i) => Text(
              _logs[i],
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
