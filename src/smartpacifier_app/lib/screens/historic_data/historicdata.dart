import 'dart:io';
import 'package:flutter/material.dart';

class HistoricData extends StatefulWidget {
  const HistoricData({Key? key}) : super(key: key);

  @override
  State<HistoricData> createState() => _HistoricDataState();
}

class _HistoricDataState extends State<HistoricData> {
  final ScrollController _verticalCtrl = ScrollController();
  final ScrollController _horizontalCtrl = ScrollController();

  final List<Map<String, String>> _rows = [];
  final List<String> _columns = [];
  int _currentPage = 1;
  final int _rowsPerPage = 20;
  bool _hasPrompted = false;

  final TextEditingController _pageInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageInput.text = '1';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPrompted) {
      _hasPrompted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _promptAndLoad());
    }
  }

  @override
  void dispose() {
    _verticalCtrl.dispose();
    _horizontalCtrl.dispose();
    _pageInput.dispose();
    super.dispose();
  }

  Future<void> _promptAndLoad() async {
    final controller = TextEditingController();
    final path = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Open Historic Data File'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Full path to .txt file',
            hintText: '/path/to/logs.txt',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Open'),
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
          ),
        ],
      ),
    );
    if (path == null || path.isEmpty) return;

    try {
      final lines = await File(path).readAsLines();
      _parseLines(lines);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open file: $e')),
      );
    }
  }

  void _parseLines(List<String> lines) {
    final cols = <String>{'timestamp', 'pacifier', 'type', 'group'};
    final parsed = <Map<String, String>>[];

    for (final line in lines) {
      final tsMatch = RegExp(r'^\[(.*?)\]').firstMatch(line);
      final ts = tsMatch?.group(1) ?? '';
      final rest = line.replaceFirst(RegExp(r'^\[.*?\]\s*'), '');
      final parts = rest.split(', data=');
      final left = parts[0];
      final dataPart = parts.length > 1
          ? parts[1].replaceFirst(RegExp(r'^\{|\}$'), '')
          : '';

      final row = <String, String>{};
      row['timestamp'] = ts;

      for (final kv in left.split(', ')) {
        final kvp = kv.split('=');
        if (kvp.length == 2) row[kvp[0]] = kvp[1];
      }

      if (dataPart.isNotEmpty) {
        for (final entry in dataPart.split(RegExp(r'\],\s*'))) {
          final m = RegExp(r'([^:\s]+):\[(.*)\]').firstMatch(entry + ']');
          if (m != null) {
            final key = m.group(1)!;
            var val = m.group(2)!;
            // strip any trailing ']' or '}'
            val = val.replaceAll(RegExp(r'[\]\}]+$'), '');
            row[key] = val;
            cols.add(key);
          }
        }
      }
      parsed.add(row);
    }

    final ordered = <String>[];
    ordered.addAll(['timestamp', 'pacifier', 'type', 'group']);
    ordered.addAll(cols
        .where((c) => !['timestamp', 'pacifier', 'type', 'group'].contains(c))
        .toList()
      ..sort());

    setState(() {
      _rows
        ..clear()
        ..addAll(parsed);
      _columns
        ..clear()
        ..addAll(ordered);
      _currentPage = 1;
      _pageInput.text = '1';
    });
  }

  void _goToPage(int p) {
    final totalPages = (_rows.length + _rowsPerPage - 1) ~/ _rowsPerPage;
    final target = p.clamp(1, totalPages);
    setState(() {
      _currentPage = target;
      _pageInput.text = '$target';
      _verticalCtrl.jumpTo(0);
      _horizontalCtrl.jumpTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_rows.length + _rowsPerPage - 1) ~/ _rowsPerPage;
    final start = (_currentPage - 1) * _rowsPerPage;
    final pageRows = _rows.skip(start).take(_rowsPerPage).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Historic Data')),
      body: _rows.isEmpty
          ? const Center(child: Text('No data loaded'))
          : Column(
        children: [
          // ── Pagination Controls ──────────────────────────
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage > 1
                      ? () => _goToPage(_currentPage - 1)
                      : null,
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _pageInput,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (v) {
                      final p = int.tryParse(v) ?? _currentPage;
                      _goToPage(p);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('/ $totalPages'),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage < totalPages
                      ? () => _goToPage(_currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),

          // ── Data Table with Dual Scrollbars ──────────────
          Expanded(
            child: Scrollbar(
              controller: _verticalCtrl,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _verticalCtrl,
                child: Scrollbar(
                  controller: _horizontalCtrl,
                  thumbVisibility: true,
                  notificationPredicate: (n) =>
                  n.metrics.axis == Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: _horizontalCtrl,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade800),
                      columns: _columns
                          .map((c) => DataColumn(
                        label: Text(
                          c[0].toUpperCase() + c.substring(1),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                          .toList(),
                      rows: pageRows.map((row) {
                        return DataRow(
                          cells: _columns.map((col) {
                            return DataCell(
                              ConstrainedBox(
                                constraints:
                                const BoxConstraints(maxWidth: 150),
                                child: Text(row[col] ?? ''),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
