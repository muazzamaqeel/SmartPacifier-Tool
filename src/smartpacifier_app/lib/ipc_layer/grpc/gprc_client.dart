import 'package:grpc/grpc.dart';

import '../../generated/google/protobuf/empty.pb.dart';
import '../../generated/myservice.pbgrpc.dart';
import '../../generated/sensor_data.pb.dart';

/// Wraps the gRPC stub and unwraps PayloadMessage → SensorData.
class MyGrpcClient {
  late final ClientChannel _channel;
  late final MyServiceClient _stub;

  MyGrpcClient() {
    _channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = MyServiceClient(_channel);
  }

  Future<void> init() async {
    // any additional startup
  }

  /// Returns a stream of actual SensorData messages.
  Stream<SensorData> streamSensorData() {
    return _stub
        .streamMessages(Empty())
        .where((payload) => payload.hasSensorData())
        .map((payload) => payload.sensorData);
  }

  Future<void> shutdown() => _channel.shutdown();
}
