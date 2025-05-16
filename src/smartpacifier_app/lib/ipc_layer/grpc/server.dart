import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:smartpacifier_app/generated/myservice.pbgrpc.dart';
import 'package:smartpacifier_app/generated/google/protobuf/empty.pb.dart';

class MyServiceImpl extends MyServiceBase {
  final _controller = StreamController<PayloadMessage>.broadcast();

  @override
  Future<Empty> publishSensorData(
      ServiceCall call,
      Stream<PayloadMessage> request,
      ) async {
    final backendName = call.clientMetadata?['backend-name'] ?? 'unknown_backend';
    debugPrint('🔔 publishSensorData() invoked from $backendName');
    await for (final msg in request) {
      msg.sensorData.sensorGroup = backendName;
      debugPrint('   → [$backendName] got payload: ${msg.sensorData}');
      _controller.add(msg);
    }
    debugPrint('🔒 publishSensorData() stream closed for $backendName');
    return Empty();
  }

  Stream<PayloadMessage> get onSensorData => _controller.stream;
}

final myService = MyServiceImpl();

Future<void> startGrpcServer({int port = 50051}) async {
  final server = await Server.create(
    services: [myService],
    interceptors: [],
    codecRegistry: CodecRegistry(codecs: [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: port);
  debugPrint('🚀 gRPC server listening on port $port');
}
