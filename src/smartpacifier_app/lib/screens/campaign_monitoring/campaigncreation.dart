// lib/screens/active_monitoring/campaigncreation.dart

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../client_layer/connector.dart';
import '../../generated/sensor_data.pb.dart' as protos;
import '../../generated/myservice.pbgrpc.dart' show PayloadMessage;
import '../active_monitoring/graphcreation.dart';

class CampaignCreation extends StatefulWidget {
  final String backend;
  const CampaignCreation({super.key, required this.backend});

  @override
  State<CampaignCreation> createState() => _CampaignCreationState();
}

class _CampaignCreationState extends State<CampaignCreation>
    with SingleTickerProviderStateMixin {
  // —— SETUP MODE ——
  final _campaignController = TextEditingController();
  final _available = <String>{};
  final _selected = <String>{};
  bool _inCampaign = false;

  // —— CAMPAIGN MODE ——
  StreamSubscription<PayloadMessage>? _sub;
  late final TabController _tabs;
  int _nextX = 0;

  /// sensorType → groupName → seriesName → spots
  final _buffers = <String, Map<String, Map<String, List<FlSpot>>>>{};

  final _logs = <String>[];
  final _palette = [
    Colors.blue, Colors.red, Colors.green,
    Colors.orange, Colors.purple, Colors.teal,
    Colors.amber, Colors.indigo, Colors.cyan, Colors.lime,
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);

    // Populate available pacifiers
    Connector().dataStreamFor(widget.backend).listen((pm) {
      final id = pm.sensorData.pacifierId;
      if (_available.add(id)) setState(() {});
    });
  }

  void _startCampaign() {
    if (_campaignController.text.trim().isEmpty || _selected.isEmpty) {
      // require name + at least one pacifier
      return;
    }

    // clear old buffers/logs
    _buffers.clear();
    _logs.clear();
    _nextX = 0;

    // subscribe
    _sub = Connector()
        .dataStreamFor(widget.backend)
        .listen(_onMessage, onError: _onError);

    setState(() => _inCampaign = true);
  }

  void _onMessage(PayloadMessage pm) {
    final sd = pm.sensorData;
    final id = sd.pacifierId;
    if (!_selected.contains(id)) return;  // **FILTER**

    final t = (_nextX++).toDouble();
    final typeMap = _buffers.putIfAbsent(sd.sensorType, () => {});
    final group = '${sd.sensorGroup}_$id';
    final groupMap = typeMap.putIfAbsent(group, () => {});

    // build spots
    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      if (bytes.length < 4) return;
      final bd = ByteData.sublistView(bytes);
      if (bytes.length == 4) {
        num v = bd.getFloat32(0, Endian.little);
        if (!v.isFinite) v = bd.getInt32(0, Endian.little);
        final series = groupMap.putIfAbsent(key, () => []);
        series.add(FlSpot(t, v.toDouble()));
        if (series.length > 50) series.removeAt(0);
      } else if (bytes.length % 4 == 0) {
        final count = bytes.length ~/ 4;
        for (var i = 0; i < count; i++) {
          num v = bd.getFloat32(i * 4, Endian.little);
          if (!v.isFinite) v = bd.getInt32(i * 4, Endian.little);
          final name = '$key[$i]';
          final series = groupMap.putIfAbsent(name, () => []);
          series.add(FlSpot(t, v.toDouble()));
          if (series.length > 50) series.removeAt(0);
        }
      }
    });

    // log
    final dataMapStr = sd.dataMap.entries
        .map((e) {
      final b = e.value is Uint8List ? e.value as Uint8List : Uint8List.fromList(e.value);
      return '${e.key}:[${b.join(',')}]';
    })
        .join(', ');
    final line = '[${DateTime.now().toIso8601String()}] '
        'pacifier=$id, type=${sd.sensorType}, group=${sd.sensorGroup}, data={$dataMapStr}';

    setState(() {
      _logs.add(line);
      if (_logs.length > 200) _logs.removeAt(0);
    });
  }

  void _onError(Object e) {
    setState(() {
      _logs.add('[${DateTime.now().toIso8601String()}] Error: $e');
      if (_logs.length > 200) _logs.removeAt(0);
    });
  }

  @override
  void dispose() {
    _campaignController.dispose();
    _sub?.cancel();
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: !_inCampaign
          ? _buildSetup()
          : _buildCampaignView(),
    );
  }

  Widget _buildSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create New Campaign',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: _campaignController,
          decoration: const InputDecoration(labelText: 'Campaign Name'),
        ),
        const SizedBox(height: 16),
        const Text('Select Pacifiers:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: _available.map((id) {
            final sel = _selected.contains(id);
            return FilterChip(
              label: Text(id),
              selected: sel,
              onSelected: (v) => setState(() {
                if (v) _selected.add(id);
                else _selected.remove(id);
              }),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _startCampaign,
          child: const Text('Start Campaign'),
        ),
      ],
    );
  }

  Widget _buildCampaignView() {
    // extract IDs actually in buffer (to show chips)
    final present = <String>{};
    for (final groups in _buffers.values) {
      for (final g in groups.keys) {
        final parts = g.split('_');
        if (parts.length >= 2) present.add(parts.last);
      }
    }
    final ids = present.toList()..sort((a, b) => int.tryParse(a)!.compareTo(int.tryParse(b)!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign — ${widget.backend}'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [Tab(text: 'Graphs'), Tab(text: 'Logs')],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          // ── GRAPHS ──
          Column(
            children: [
              if (ids.isNotEmpty)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ids.map((id) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('Pacifier $id'),
                        selected: _selected.contains(id),
                        onSelected: (_) {}, // no-op: fixed selection
                      ),
                    )).toList(),
                  ),
                ),
              Expanded(
                child: ListView(
                  children: _selected.map((id) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Pacifier $id',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Builder(builder: (_) {
                          // filter buffers
                          final filtered = <String, Map<String, Map<String, List<FlSpot>>>>{};
                          _buffers.forEach((stype, groups) {
                            final sub = <String, Map<String, List<FlSpot>>>{};
                            groups.forEach((gname, series) {
                              if (gname.endsWith('_$id')) sub[gname] = series;
                            });
                            if (sub.isNotEmpty) filtered[stype] = sub;
                          });
                          if (filtered.isEmpty) return const SizedBox();
                          return GraphCreation.buildGraphs(filtered, _palette);
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // ── LOGS ──
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _logs.length,
            itemBuilder: (_, i) =>
                Text(_logs[i], style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
