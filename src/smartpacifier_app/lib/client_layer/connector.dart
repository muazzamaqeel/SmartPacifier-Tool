import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:smartpacifier_app/ipc_layer/grpc/server.dart' show myService;
import 'package:smartpacifier_app/generated/myservice.pbgrpc.dart';

/// Discovers actual backends by watching incoming stream,
/// and exposes per-backend filtered data streams.
class Connector {
  Connector._internal() {
    // Whenever *any* payload arrives, record its sensorGroup
    myService.onSensorData.listen((pm) {
      final name = pm.sensorData.sensorGroup;
      if (_clients.add(name)) {
        _ctrl.add(_clients.toList());
      }
    }, onError: (e) {
      debugPrint('❌ Connector got error: $e');
    });
  }
  static final Connector _instance = Connector._internal();
  factory Connector() => _instance;

  final Set<String> _clients = <String>{};
  final _ctrl = StreamController<List<String>>.broadcast();

  /// Emits the *live* list of backend names as soon as they first send data.
  Stream<List<String>> get clientsStream => _ctrl.stream;

  /// Snapshot of current backends.
  List<String> get clients => List.unmodifiable(_clients);

  /// Stream of only those PayloadMessages whose sensorGroup matches [backendName].
  Stream<PayloadMessage> dataStreamFor(String backendName) {
    return myService.onSensorData.where(
          (pm) => pm.sensorData.sensorGroup == backendName,
    );
  }
}
