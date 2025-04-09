import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:smartpacifier_app/ipc_layer/grpc/generated/myservice.pbgrpc.dart';
import 'package:smartpacifier_app/ipc_layer/grpc/generated/google/protobuf/empty.pb.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPacifier App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainWindow(),
    );
  }
}

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  late ClientChannel _channel;
  late MyServiceClient _stub;

  @override
  void initState() {
    super.initState();

    // Connect to your gRPC backend.
    _channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = MyServiceClient(_channel);

    // Subscribe to the StreamMessages RPC.
    // Note: 'Empty' comes from google/protobuf/empty.proto, which is now available via your generated files.
    _stub.streamMessages(Empty()).listen(
      (PayloadMessage payload) {
        // Check if the sensor_data field is set.
        if (payload.hasSensorData()) {
          final sensorData = payload.sensorData;
          setState(() {
            _logs.add('Received SensorData: type=${sensorData.sensorType}, id=${sensorData.pacifierId}');
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

  /// Scroll the log view to the bottom.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _channel.shutdown();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF001B3A),
        title: const Text('Active Monitoring', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top display area.
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
            // Log/console area.
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
        ),
      ),
    );
  }
}
