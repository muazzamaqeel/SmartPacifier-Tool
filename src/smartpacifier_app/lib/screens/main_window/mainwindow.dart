import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartpacifier_app/ipc_layer/grpc/generated/myservice.pbgrpc.dart';
import 'package:smartpacifier_app/ipc_layer/grpc/generated/google/protobuf/empty.pb.dart';

/// Used to switch between the Raw Data view and the Graphs view.
enum TabSelection { rawData, graphs }

/// A simple data model for plotting purposes.
class ChartPoint {
  final DateTime time;
  final double value;

  ChartPoint(this.time, this.value);
}

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  // List for debug logs (raw data).
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  // Lists to store sensor values.
  final List<ChartPoint> imuDataPoints = [];
  final List<ChartPoint> ppgDataPoints = [];

  late ClientChannel _channel;
  late MyServiceClient _stub;

  // Tracks which view (Raw Data or Graphs) is visible.
  TabSelection _selectedTab = TabSelection.rawData;

  @override
  void initState() {
    super.initState();

    _channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = MyServiceClient(_channel);

    // Subscribe to your gRPC stream.
    _stub.streamMessages(Empty()).listen(
          (PayloadMessage payload) {
        final now = DateTime.now();

        if (payload.hasSensorData()) {
          final sensorData = payload.sensorData;
          final type = sensorData.sensorType.toLowerCase();

          // Parse the pacifierId to a double.
          final value = double.tryParse(sensorData.pacifierId) ?? 0.0;

          if (type == 'imu') {
            imuDataPoints.add(ChartPoint(now, value));
          } else if (type == 'ppg') {
            ppgDataPoints.add(ChartPoint(now, value));
          }

          setState(() {
            _logs.add('Received SensorData: type=$type, id=${sensorData.pacifierId}');
          });
        } else {
          setState(() {
            _logs.add('Received PayloadMessage with no sensor_data set.');
          });
        }
        _scrollToBottom();
      },
      onError: (error) {
        setState(() {
          _logs.add('Error: $error');
        });
        _scrollToBottom();
      },
    );
  }

  /// Ensures the log ListView scrolls to the bottom when new data arrives.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// Switch between views when the sidebar buttons are pressed.
  void _onTabSelected(TabSelection selection) {
    setState(() {
      _selectedTab = selection;
    });
  }

  /// Builds the UI to display raw sensor data logs.
  Widget _buildRawDataView() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Color(0xFF002F5F)],
              ),
            ),
            child: const Center(
              child: Text(
                'Active Monitoring',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF001B3A),
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _logs[index],
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the view displaying graphs for IMU and PPG data using fl_chart.
  Widget _buildGraphsView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLineChart(imuDataPoints, 'IMU Data'),
            const SizedBox(height: 32),
            _buildLineChart(ppgDataPoints, 'PPG Data'),
          ],
        ),
      ),
    );
  }

  /// A helper that builds a LineChart (using fl_chart) for a given set of data.
  Widget _buildLineChart(List<ChartPoint> data, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            _buildLineChartData(data),
          ),
        ),
      ],
    );
  }

  /// Builds the LineChartData for the [LineChart] widget.
  LineChartData _buildLineChartData(List<ChartPoint> data) {
    if (data.isEmpty) {
      return LineChartData(
        lineTouchData: LineTouchData(enabled: true),
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [],
      );
    }

    // Convert timestamp to relative seconds (starting from zero)
    final start = data.first.time.millisecondsSinceEpoch / 1000.0;
    final spots = data.map((p) {
      final x = (p.time.millisecondsSinceEpoch / 1000.0) - start;
      return FlSpot(x, p.value);
    }).toList();

    // Determine min and max values for axes
    double minX = spots.first.x, maxX = spots.first.x;
    double minY = spots.first.y, maxY = spots.first.y;
    for (var spot in spots) {
      if (spot.x < minX) minX = spot.x;
      if (spot.x > maxX) maxX = spot.x;
      if (spot.y < minY) minY = spot.y;
      if (spot.y > maxY) maxY = spot.y;
    }

    final marginX = (maxX - minX) * 0.1;
    final marginY = (maxY - minY) * 0.1;

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: minX - marginX,
      maxX: maxX + marginX,
      minY: minY - marginY,
      maxY: maxY + marginY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 2,
          color: Colors.blue,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _channel.shutdown();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which view to show based on the sidebar selection.
    final contentWidget = _selectedTab == TabSelection.rawData
        ? _buildRawDataView()
        : _buildGraphsView();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF001B3A),
        title: const Text(
          'SmartPacifier App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Row(
        children: [
          // Sidebar with two buttons: Raw Data and Graphs.
          Container(
            width: 200,
            color: Colors.grey[900],
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  title: const Text('Raw Data', style: TextStyle(color: Colors.white)),
                  onTap: () => _onTabSelected(TabSelection.rawData),
                  selected: _selectedTab == TabSelection.rawData,
                  selectedTileColor: Colors.grey[800],
                ),
                ListTile(
                  title: const Text('Graphs', style: TextStyle(color: Colors.white)),
                  onTap: () => _onTabSelected(TabSelection.graphs),
                  selected: _selectedTab == TabSelection.graphs,
                  selectedTileColor: Colors.grey[800],
                ),
              ],
            ),
          ),
          // Main content area that displays either the raw data or graphs.
          Expanded(child: SafeArea(child: contentWidget)),
        ],
      ),
    );
  }
}
