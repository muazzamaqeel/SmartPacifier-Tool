// lib/ipc_layer/grpc/gprc_client.dart

import 'package:grpc/grpc.dart';
import '../../generated/myservice.pbgrpc.dart';
import '../../generated/sensor_data.pb.dart';
import '../../generated/google/protobuf/empty.pb.dart' as $pb;

/// Singleton gRPC client for MyService.
class MyGrpcClient {
  MyGrpcClient._();
  static final MyGrpcClient _instance = MyGrpcClient._();
  factory MyGrpcClient() => _instance;

  late MyServiceClient stub;
  late ClientChannel channel;
  bool isConnected = false;

  /// Connects to the server at [host]:[port].
  Future<void> init({String host = '127.0.0.1', int port = 50051}) async {
    channel = ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    stub = MyServiceClient(channel);
    isConnected = true;
    print('✅ Connected to $host:$port');
  }

  /// Streams fully parsed SensorData messages.
  Stream<SensorData> streamSensorData() async* {
    if (!isConnected) {
      throw StateError('gRPC client not initialized');
    }

    final request = $pb.Empty();
    await for (final payload in stub.streamMessages(request)) {
      if (payload.hasSensorData()) {
        yield payload.sensorData;
      }
    }
  }

  /// Cleanly shuts down the channel.
  Future<void> shutdown() async {
    await channel.shutdown();
    isConnected = false;
    print('🛑 Disconnected');
  }
}
