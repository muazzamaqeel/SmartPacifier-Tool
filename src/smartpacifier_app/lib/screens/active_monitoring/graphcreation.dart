import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphCreation {
  /// [buffers]: sensorType → groupName → seriesName → spots
  /// [palette]: list of colors to cycle through
  static Widget buildGraphs(
      Map<String, Map<String, Map<String, List<FlSpot>>>> buffers,
      List<Color> palette,
      ) {
    final children = <Widget>[];

    buffers.forEach((sensorType, groups) {
      // Sensor header
      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          sensorType.toUpperCase(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ));

      // Flatten all series into measurement buckets
      final combined = <String, List<FlSpot>>{};
      for (final seriesMap in groups.values) {
        combined.addAll(seriesMap);
      }

      final measurementMap = <String, Map<String, List<FlSpot>>>{};
      combined.forEach((seriesName, spots) {
        final measurement = seriesName.split(RegExp(r'[_\[]')).first;
        measurementMap
            .putIfAbsent(measurement, () => <String, List<FlSpot>>{})[seriesName] =
            spots;
      });

      final measurements = measurementMap.keys.toList()..sort();
      for (final measurement in measurements) {
        final subSeries = measurementMap[measurement]!;
        children.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: _buildChartCard(measurement, subSeries, palette),
        ));
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  static Widget _buildChartCard(
      String title,
      Map<String, List<FlSpot>> seriesMap,
      List<Color> palette,
      ) {
    // find max X to invert timeline (if desired)
    final allXs = seriesMap.values.expand((spots) => spots.map((s) => s.x));
    final maxX = allXs.isEmpty ? 0.0 : allXs.reduce(max);

    final seriesNames = seriesMap.keys.toList()..sort();
    final bars = <LineChartBarData>[];

    for (var i = 0; i < seriesNames.length; i++) {
      final originalSpots = seriesMap[seriesNames[i]]!;
      final invertedSpots = originalSpots
          .map((pt) => FlSpot(maxX - pt.x, pt.y))
          .toList(growable: false);

      bars.add(LineChartBarData(
        spots: invertedSpots,
        isCurved: true,
        curveSmoothness: 0.2,                   // <-- smooth curve
        dotData: FlDotData(show: false),
        color: palette[i % palette.length],
        barWidth: 4.0,                          // <-- bolder line
        belowBarData: BarAreaData(              // <-- translucent fill
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette[i % palette.length].withOpacity(0.3),
              palette[i % palette.length].withOpacity(0.0),
            ],
          ),
        ),
      ));
    }

    // simple legend
    final legend = Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        for (var i = 0; i < seriesNames.length; i++) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: palette[i % palette.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(seriesNames[i],
                  style: const TextStyle(fontSize: 12, height: 1.2)),
            ],
          )
        ]
      ],
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            legend,
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  lineBarsData: bars,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingVerticalLine: (_) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
