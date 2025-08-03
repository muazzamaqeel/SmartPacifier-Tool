// File: ipc_layer/grpc/server.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:smartpacifier_app/generated/myservice.pbgrpc.dart';
import 'package:smartpacifier_app/generated/google/protobuf/empty.pb.dart';

class MyServiceImpl extends MyServiceBase {
  /// Broadcast controller in synchronous mode: delivers each add() immediately.
  final _controller = StreamController<PayloadMessage>.broadcast(sync: true);

  @override
  Future<Empty> publishSensorData(
      ServiceCall call,
      Stream<PayloadMessage> request,
      ) async {
    // Extract backend identifier from metadata
    final backendName = call.clientMetadata?['backend-name'] ?? 'unknown_backend';
    debugPrint('publishSensorData() started for $backendName');

    await for (final msg in request) {
      // Tag the payload with its source
      msg.sensorData.sensorGroup = backendName;

      // Log the deserialized payload with actual values
      final timestamp = DateTime.now().toIso8601String();
      debugPrint(
        '[$timestamp] '
            '[$backendName] '
            'pacifier=${msg.sensorData.pacifierId}, '
            'type=${msg.sensorData.sensorType}, '
            'group=${msg.sensorData.sensorGroup}, '
            'data=${msg.sensorData.dataMap}',
      );

      // Forward immediately to Flutter listeners
      _controller.add(msg);
    }

    debugPrint('publishSensorData() completed for $backendName');
    return Empty();
  }

  @override
  Stream<PayloadMessage> get onSensorData => _controller.stream;
}

/// Shared instance for Connector to import
final myService = MyServiceImpl();

/// Starts the gRPC server on [port] (default: 50051)
Future<void> startGrpcServer({int port = 50051}) async {
  final server = await Server.create(
    services: [myService],
    codecRegistry: CodecRegistry(codecs: [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: port);
  debugPrint('gRPC server listening on port \$port');
}