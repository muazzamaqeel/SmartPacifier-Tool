import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:grpc/grpc.dart';

// Generated bits
import '../../generated/myservice.pbgrpc.dart';
import '../../generated/google/protobuf/empty.pb.dart';

class MyServiceImpl extends MyServiceBase {
  final _controller = StreamController<PayloadMessage>.broadcast();

  @override
  Future<Empty> publishSensorData(
      ServiceCall call,
      Stream<PayloadMessage> request,
      ) async {
    // Read the metadata header (no .first since it's a String)
    final backendName = call.clientMetadata?['backend-name'] ?? 'unknown_backend';

    debugPrint('🔔 publishSensorData() invoked from $backendName');
    await for (final msg in request) {
      // Stamp each message’s sensorGroup with the backend name
      msg.sensorData.sensorGroup = backendName;

      debugPrint('   → [$backendName] got payload.sensorData: ${msg.sensorData}');
      _controller.add(msg);
    }
    debugPrint('🔒 publishSensorData() stream closed for $backendName');
    return Empty();
  }

  Stream<PayloadMessage> get onSensorData => _controller.stream;
}

/// Export a single server instance
final myService = MyServiceImpl();

/// Starts the in‐app server on [port]
Future<void> startGrpcServer({int port = 50051}) async {
  // Use the new Server.create() API instead of the deprecated constructor
  final server = await Server.create(
    services: [myService],
    interceptors: [],
    codecRegistry: CodecRegistry(codecs: [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: port);
  debugPrint('🚀 gRPC server listening on port $port');
}
