import 'dart:async';
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
    print('🔔 publishSensorData() invoked');
    await for (final msg in request) {
      print('   → got payload.sensorData: ${msg.sensorData}');
      _controller.add(msg);
    }
    print('🔒 publishSensorData() stream closed');
    return Empty();
  }

  Stream<PayloadMessage> get onSensorData => _controller.stream;
}

/// Export a single server instance
final myService = MyServiceImpl();

/// Starts the in‐app server on [port]
Future<void> startGrpcServer({int port = 50051}) async {
  final server = Server(
    [myService],
    <Interceptor>[],
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: port);
  print('🚀 gRPC server listening on port $port');
}
