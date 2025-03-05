// lib/screens/mainwindow.dart
import 'package:flutter/material.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  // Placeholder logs for demonstration
  final List<String> _logs = [
    'Log 1: Application started',
    'Log 2: User clicked a button',
    'Log 3: BLE device connected',
    'Log 4: Data received: { temperature: 36.5 }',
    'Log 5: Application paused',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Overall dark background
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Dark navy-blue AppBar
        backgroundColor: const Color(0xFF001B3A),
        title: const Text(
          '',
          // White text for contrast
          style: TextStyle(color: Colors.white),
        ),
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
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
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
