// lib/screens/active_monitoring/campaigncreation.dart

import 'dart:async';
import 'dart:io';
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
    Connector().dataStreamFor(widget.backend).listen((pm) {
      final id = pm.sensorData.pacifierId;
      if (_available.add(id)) setState(() {});
    });
    _tabs = TabController(length: 2, vsync: this);
  }

  void _startCampaign() {
    if (_campaignController.text.trim().isEmpty || _selected.isEmpty) return;
    _buffers.clear();
    _logs.clear();
    _nextX = 0;
    _sub = Connector()
        .dataStreamFor(widget.backend)
        .listen(_onData, onError: _onError);
    setState(() => _inCampaign = true);
  }

  void _onData(PayloadMessage pm) {
    final sd = pm.sensorData;
    final t = (_nextX++).toDouble();
    if (!_selected.contains(sd.pacifierId)) return;

    final typeMap = _buffers.putIfAbsent(sd.sensorType, () => {});
    final groupName = '${sd.sensorGroup}_${sd.pacifierId}';
    final groupMap = typeMap.putIfAbsent(groupName, () => {});

    sd.dataMap.forEach((key, raw) {
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      if (bytes.length < 4) return;
      final bd = ByteData.sublistView(bytes);

      void addValue(String name, num v) {
        final s = groupMap.putIfAbsent(name, () => []);
        s.add(FlSpot(t, v.toDouble()));
        if (s.length > 50) s.removeAt(0);
      }

      if (bytes.length == 4) {
        num v = bd.getFloat32(0, Endian.little);
        if (!v.isFinite) v = bd.getInt32(0, Endian.little);
        addValue(key, v);
      } else if (bytes.length % 4 == 0) {
        for (var i = 0; i < bytes.length ~/ 4; i++) {
          num v = bd.getFloat32(i * 4, Endian.little);
          if (!v.isFinite) v = bd.getInt32(i * 4, Endian.little);
          addValue('$key[$i]', v);
        }
      }
    });

    final dataMapStr = sd.dataMap.entries.map((e) {
      final b = e.value is Uint8List
          ? e.value as Uint8List
          : Uint8List.fromList(e.value);
      return '${e.key}:[${b.join(",")}]';
    }).join(', ');

    _logs.add(
      '[${DateTime.now().toIso8601String()}] pacifier=${sd.pacifierId}, '
          'type=${sd.sensorType}, group=${sd.sensorGroup}, data={$dataMapStr}',
    );
    if (_logs.length > 200) _logs.removeAt(0);

    if (mounted) setState(() {});
  }

  void _onError(Object err) {
    _logs.add('[${DateTime.now().toIso8601String()}] Error: $err');
    if (_logs.length > 200) _logs.removeAt(0);
    setState(() {});
  }

  Future<void> _endCampaign() async {
    final pathCtrl = TextEditingController();
    String? errorText;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setInner) {
          return AlertDialog(
            title: const Text('Save Campaign Logs'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: pathCtrl,
                decoration: InputDecoration(
                  labelText: 'Full file path',
                  hintText: '/home/user/camp.txt or C:\\Logs\\camp.txt',
                  errorText: errorText,
                ),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx2),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final p = pathCtrl.text.trim();
                  // validation
                  if (p.isEmpty || !p.toLowerCase().endsWith('.txt')) {
                    setInner(() {
                      errorText = 'Path must end with “.txt”';
                    });
                    return;
                  }
                  final dir = Directory(p).parent;
                  if (!dir.existsSync()) {
                    setInner(() {
                      errorText = 'Directory does not exist';
                    });
                    return;
                  }
                  Navigator.pop(ctx2, p);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );

    if (result == null) return;

    try {
      final file = File(result);
      file.writeAsStringSync(_logs.join('\n'));
      await _sub?.cancel();
      _sub = null;
      setState(() {
        _inCampaign = false;
        _selected.clear();
        _buffers.clear();
        _logs.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logs saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
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
    if (!_inCampaign) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                  label: Text('Pacifier $id'),
                  selected: sel,
                  onSelected: (_) =>
                      setState(() => sel ? _selected.remove(id) : _selected.add(id)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startCampaign,
              child: const Text('Start Campaign'),
            ),
          ],
        ),
      );
    }

    final pacs = _selected.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign — ${widget.backend} (${_campaignController.text})'),
        actions: [
          TextButton(
            onPressed: _endCampaign,
            child: const Text('End'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
        bottom: TabBar(controller: _tabs, tabs: const [
          Tab(text: 'Graphs'),
          Tab(text: 'Logs'),
        ]),
      ),
      body: TabBarView(controller: _tabs, children: [
        // Graphs
        Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: pacs.map((id) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('Pacifier $id'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView(
              children: pacs.expand((id) {
                return [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Pacifier $id',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Builder(builder: (_) {
                    final filtered = <String,
                        Map<String, Map<String, List<FlSpot>>>>{};
                    _buffers.forEach((stype, groups) {
                      final sub = <String, Map<String, List<FlSpot>>>{};
                      groups.forEach((g, series) {
                        if (g.endsWith('_$id')) sub[g] = series;
                      });
                      if (sub.isNotEmpty) filtered[stype] = sub;
                    });
                    return filtered.isEmpty
                        ? const SizedBox()
                        : GraphCreation.buildGraphs(filtered, _palette);
                  }),
                ];
              }).toList(),
            ),
          ),
        ]),
        // Logs
        ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _logs.length,
          itemBuilder: (_, i) =>
              Text(_logs[i], style: const TextStyle(fontSize: 12)),
        ),
      ]),
    );
  }
}
