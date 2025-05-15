import 'package:flutter/material.dart';
import 'ipc_layer/grpc/server.dart';
import 'screens/app_shell.dart';  // ← point at your new shell

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Start your in‐app gRPC server
  await startGrpcServer(port: 50051);

  // 2️⃣ Launch the Flutter UI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        title: 'SmartPacifier App',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AppShell(),  // ← use AppShell here instead of MainWindow
      );
}
