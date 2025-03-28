import 'package:flutter/material.dart';
import '../ipc_layer/grpc/gprc_client.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize the gRPC client and subscribe to the stream.
    MyGrpcClient().init(host: 'localhost', port: 50051).then((_) {
      MyGrpcClient().streamMessages().listen((message) {
        setState(() {
          _logs.add("Received: $message");
        });
        _scrollToBottom();
      }, onError: (error) {
        setState(() {
          _logs.add("Error: $error");
        });
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    // Schedule a scroll to the bottom of the ListView
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Overall dark background
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Dark navy-blue AppBar
        backgroundColor: const Color(0xFF001B3A),
        title: const Text('Active Monitoring', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top area (flex:2)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  // Gradient from black to dark blue
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black,
                        Color(0xFF002F5F), // Dark navy-blue
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Active Monitoring',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom area for the "console logs" (flex:4)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  // Dark navy container for logs
                  decoration: BoxDecoration(
                    color: const Color(0xFF001B3A),
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      controller: _scrollController,  // Attach the scroll controller
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _logs[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
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
