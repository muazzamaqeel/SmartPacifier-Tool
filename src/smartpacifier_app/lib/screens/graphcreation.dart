// File: screens/graphcreation.dart

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
      // 1) Sensor header (once per sensorType)
      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          sensorType.toUpperCase(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ));

      // 2) Flatten all groups into one map: seriesName → spots
      final combined = <String, List<FlSpot>>{};
      for (final seriesMap in groups.values) {
        combined.addAll(seriesMap);
      }

      // 3) Bucket by measurement prefix
      final measurementMap = <String, Map<String, List<FlSpot>>>{};
      combined.forEach((seriesName, spots) {
        final measurement = seriesName.split(RegExp(r'[_\[]')).first;
        measurementMap
            .putIfAbsent(measurement, () => <String, List<FlSpot>>{})
        [seriesName] = spots;
      });

      // 4) One card per measurement (sorted for consistency)
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
    // Sort seriesNames so color assignment is stable
    final seriesNames = seriesMap.keys.toList()..sort();
    final bars = <LineChartBarData>[];

    for (var i = 0; i < seriesNames.length; i++) {
      final name = seriesNames[i];
      final spots = seriesMap[name]!;
      bars.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        dotData: FlDotData(show: false),
        color: palette[i % palette.length],
        barWidth: 2,
      ));
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // To define the measurement name: For example
            // "gyro", "mag", "acc", "led", "temperature"
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: LineChart(
                LineChartData(
                  lineBarsData: bars,
                  gridData: FlGridData(show: true),
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
