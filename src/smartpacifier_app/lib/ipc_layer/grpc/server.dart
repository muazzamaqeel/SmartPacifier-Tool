import 'dart:async';
import 'package:grpc/grpc.dart';
import '../../generated/myservice.pbgrpc.dart';
import '../../generated/google/protobuf/empty.pb.dart';

class MyServiceImpl extends MyServiceBase {
  final _controller = StreamController<PayloadMessage>.broadcast();

  @override
  Future<Empty> publishSensorData(
      ServiceCall call, Stream<PayloadMessage> request) async {
    await for (final msg in request) {
      _controller.add(msg);
    }
    return Empty();
  }

  Stream<PayloadMessage> get onSensorData => _controller.stream;
}

final myService = MyServiceImpl();

Future<void> startGrpcServer({int port = 50051}) async {
  final server = Server(
    [myService],
    const <Interceptor>[],
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: port);
  print('🚀 gRPC server listening on port $port');
}
