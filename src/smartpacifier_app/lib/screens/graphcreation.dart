import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphCreation {
  /// buffers: sensorType → groupName → seriesName → spots
  static Widget buildGraphs(
      Map<String, Map<String, Map<String, List<FlSpot>>>> buffers,
      List<Color> palette,
      ) {
    final children = <Widget>[];

    buffers.forEach((sensorType, groups) {
      // big header (e.g. "IMU", "PPG")
      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          sensorType.toUpperCase(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ));

      // one card per pacifier‐stream
      groups.forEach((_, seriesMap) {
        // use the series keys as the title ("gyro_y", "led_2", etc.)
        final title = seriesMap.keys.join(', ');
        children.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildChartCard(title, seriesMap, palette),
        ));
      });
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
    final bars = <LineChartBarData>[];
    var colorIdx = 0;

    seriesMap.forEach((seriesName, spots) {
      bars.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        dotData: FlDotData(show: false),
        color: palette[colorIdx % palette.length],
        barWidth: 2,
      ));
      colorIdx++;
    });

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // now shows "gyro_y" or "led_2"
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
