import 'package:grpc/grpc.dart';
import '../../generated/google/protobuf/empty.pb.dart';
import '../../generated/myservice.pbgrpc.dart' show MyServiceClient, PayloadMessage;
import '../../generated/sensor_data.pb.dart'   show SensorData;

class MyGrpcClient {
  late final ClientChannel _channel;
  late final MyServiceClient _stub;

  Future<void> init({
    String host = '127.0.0.1',
    int    port = 50051,
  }) async {
    _channel = ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _stub = MyServiceClient(
      _channel,
      options: CallOptions(timeout: const Duration(seconds: 30)),
    );
  }

  /// Now returns *SensorData* directly.
  Stream<SensorData> streamSensorData() {
    return _stub
        .streamMessages(Empty())         // Stream<PayloadMessage>
        .map((pm) => pm.sensorData);     // → Stream<SensorData>
  }

  Future<void> shutdown() => _channel.shutdown();
}
