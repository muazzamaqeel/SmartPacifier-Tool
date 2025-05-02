import 'package:flutter/material.dart';
import 'ipc_layer/grpc/server.dart';
import 'screens/mainwindow.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ⚠️ Don’t await this—if you `await`, it never returns, so `runApp` never runs!
  startGrpcServer(port: 50051);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SmartPacifier App',
    theme: ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: const MainWindow(),
  );
}
