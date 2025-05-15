// File: client_layer/connector.dart

import 'dart:async';
import '../ipc_layer/grpc/server.dart' show myService;
import '../generated/myservice.pbgrpc.dart' show PayloadMessage;
import 'package:flutter/foundation.dart';

/// Discovers backend “clients” via the gRPC sensor stream and broadcasts the current list.
class Connector {
  Connector._internal() {
    _initDetection();
  }
  static final Connector _instance = Connector._internal();
  factory Connector() => _instance;

  final Set<String> _clients = {};
  final _ctrl = StreamController<List<String>>.broadcast();

  /// Emits whenever the backend list changes.
  Stream<List<String>> get clientsStream => _ctrl.stream;

  /// Current snapshot.
  List<String> get clients => List.unmodifiable(_clients);

  void _initDetection() {
    // Listen to the gRPC sensor stream to detect active backend groups.
    myService.onSensorData.listen((PayloadMessage msg) {
      if (!msg.hasSensorData()) return;
      final group = msg.sensorData.sensorGroup;
      if (group.isNotEmpty && _clients.add(group)) {
        _ctrl.add(_clients.toList());
      }
    }, onError: (e) {
      debugPrint('Connector error: $e');
    });
  }

  /// Manually add a backend (if needed)
  void addClient(String name) {
    if (_clients.add(name)) _ctrl.add(_clients.toList());
  }

  /// Manually remove a backend (if needed)
  void removeClient(String name) {
    if (_clients.remove(name)) _ctrl.add(_clients.toList());
  }
}
