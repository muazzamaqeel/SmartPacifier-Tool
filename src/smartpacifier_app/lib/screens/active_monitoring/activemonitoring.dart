// lib/screens/active_monitoring/activemonitoring.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    with TickerProviderStateMixin {
  StreamSubscription<PayloadMessage>? _sub;

  /// sensorType → groupName → seriesName → list of spots
  final Map<String, Map<String, Map<String, List<FlSpot>>>> _buffers = {};

  final Set<String> _selectedPacifiers = {};
  final List<String> _logs = [];

  late final TabController _tabController;
  int _nextX = 0;

  // measure inflow rate
  int _packetCount = 0;
  final ValueNotifier<double> _hzNotifier = ValueNotifier(0);

  Timer? _hzTimer;

  // ticker for ~60Hz redraw
  late final Ticker _ticker;
  bool _needsRebuild = false;

  final List<Color> _palette = [
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
    _tabController = TabController(length: 2, vsync: this);

    // Ticker to rebuild only when needed (~60FPS)
    _ticker = createTicker((_) {
      if (_needsRebuild && mounted) {
        setState(() {
          _needsRebuild = false;
        });
      }
    })..start();

    // Hz counter: update notifier once/sec
    _hzTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _hzNotifier.value = _packetCount.toDouble();
      _packetCount = 0;
    });

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
      _packetCount = 0;
      _hzNotifier.value = 0;
      _needsRebuild = true;
      _subscribe();
    }
  }

  void _subscribe() {
    _sub = Connector()
        .dataStreamFor(widget.backend)
        .listen((pm) {
      // count packet
      _packetCount++;

      // process into buffers
      _handleSensorData(pm.sensorData);

      // mark for redraw on next tick
      _needsRebuild = true;

      // append log
      final sd = pm.sensorData;
      final dataMapStr = sd.dataMap.entries.map((e) {
        final bytes = e.value is Uint8List
            ? (e.value as Uint8List)
            : Uint8List.fromList(e.value);
        return '${e.key}:[${bytes.join(',')}]';
      }).join(', ');

      final line = '[${DateTime.now().toIso8601String()}] '
          '[${widget.backend}] pacifier=${sd.pacifierId}, '
          'type=${sd.sensorType}, group=${sd.sensorGroup}, data={$dataMapStr}';

      _logs.add(line);
      if (_logs.length > 200) _logs.removeAt(0);
    }, onError: (e) {
      _logs.add('[${DateTime.now().toIso8601String()}] '
          'Error from ${widget.backend}: $e');
      if (_logs.length > 200) _logs.removeAt(0);
      _needsRebuild = true;
    });
  }

  void _handleSensorData(protos.SensorData sd) {
    final t = (_nextX++).toDouble();
    final typeMap = _buffers.putIfAbsent(
      sd.sensorType,
          () => <String, Map<String, List<FlSpot>>>{},
    );
    final groupName = '${sd.sensorGroup}_${sd.pacifierId}';
    final groupMap = typeMap.putIfAbsent(
      groupName,
          () => <String, List<FlSpot>>{},
    );

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
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ticker.dispose();
    _hzTimer?.cancel();
    _hzNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // extract pacifier IDs
    final pacifierIds = <String>{};
    for (final groups in _buffers.values) {
      for (final g in groups.keys) {
        pacifierIds.add(g.split('_').last);
      }
    }
    pacifierIds.removeWhere((id) => id.isEmpty);
    final pacifierList = pacifierIds.toList()
      ..sort((a, b) => int.tryParse(a)!.compareTo(int.tryParse(b)!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Monitoring — ${widget.backend}'),
        actions: [
          ValueListenableBuilder<double>(
            valueListenable: _hzNotifier,
            builder: (_, hz, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '${hz.toStringAsFixed(0)} Hz',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Graphs'), Tab(text: 'Logs')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ───── GRAPHS ─────────────────────────────────────────────
          RepaintBoundary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                                  sel
                                      ? _selectedPacifiers.add(id)
                                      : _selectedPacifiers.remove(id);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                Expanded(
                  child: _selectedPacifiers.isEmpty
                      ? const Center(child: Text('Select a chip to show graphs'))
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
                        Builder(builder: (_) {
                          final filtered = <String,
                              Map<String, Map<String, List<FlSpot>>>>{};
                          _buffers.forEach((stype, groups) {
                            final sub = <String, Map<String, List<FlSpot>>>{};
                            groups.forEach((gname, series) {
                              if (gname.endsWith('_$id')) {
                                sub[gname] = series;
                              }
                            });
                            if (sub.isNotEmpty) filtered[stype] = sub;
                          });
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
          ),

          // ───── LOGS ────────────────────────────────────────────────
          RepaintBoundary(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _logs.length,
              itemBuilder: (_, i) =>
                  Text(_logs[i], style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
