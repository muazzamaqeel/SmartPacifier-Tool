// File: lib/client_layer/connector.dart

import 'dart:async';
import 'package:smartpacifier_app/generated/myservice.pbgrpc.dart';
import 'package:smartpacifier_app/ipc_layer/grpc/server.dart';

/// Discovers backend “clients” and broadcasts the current list.
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

  Future<void> _initDetection() async {
    // TODO: Replace with real discovery (mDNS, REST, etc.)
    await Future.delayed(const Duration(seconds: 1));
    addClient('C++ BackEnd');
    await Future.delayed(const Duration(seconds: 2));
    addClient('python_bridge');
  }

  /// Call when a new backend appears.
  void addClient(String name) {
    if (_clients.add(name)) {
      _ctrl.add(_clients.toList());
    }
  }

  /// Call when a backend disappears.
  void removeClient(String name) {
    if (_clients.remove(name)) {
      _ctrl.add(_clients.toList());
    }
  }

  /// Returns a stream of only those PayloadMessages coming from [clientId].
  Stream<PayloadMessage> dataStreamFor(String clientId) {
    return myService.onSensorData.where((pm) {
      final incoming = pm.sensorData.sensorGroup;
      return incoming == clientId;
    });
  }
}
