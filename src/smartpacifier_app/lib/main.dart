import 'package:flutter/material.dart';
import 'ipc_layer/grpc/server.dart';
import 'components/theme/lighttheme.dart';
import 'components/theme/darktheme.dart';
import 'components/sidebar/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startGrpcServer(port: 50051);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = true;

  void _toggleTheme(bool isDark) {
    setState(() => _isDark = isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPacifier App',
      theme: _isDark ? darkTheme : lightTheme,
      home: AppShell(
        isDark: _isDark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
