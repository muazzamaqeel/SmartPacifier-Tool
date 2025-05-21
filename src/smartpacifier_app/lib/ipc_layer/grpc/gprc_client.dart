import 'package:grpc/grpc.dart';
import 'myservice.pbgrpc.dart';
import 'google/protobuf/empty.pb.dart';

class MyGrpcClient {
  MyGrpcClient._internal();
  static final MyGrpcClient _instance = MyGrpcClient._internal();
  factory MyGrpcClient() => _instance;

  late MyServiceClient stub;
  late ClientChannel channel;
  bool isConnected = false;

  Future<void> init({String host = '127.0.0.1', int port = 50051}) async {
    try {
      channel = ClientChannel(
        host,
        port: port,
        options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
      stub = MyServiceClient(channel);
      isConnected = true;
      print("✅ gRPC Client connected to $host:$port");
    } catch (e) {
      isConnected = false;
      print("❌ gRPC Client initialization failed: $e");
    }
  }

  Stream<String> streamMessages() async* {
    if (!isConnected) {
      print("⚠️ gRPC Client is not connected!");
      yield "Error: Not connected to gRPC server.";
      return;
    }

    try {
      print("📡 Streaming messages from gRPC server...");
      await for (var response in stub.streamMessages(Empty())) {
        print("📩 Received: ${response.value}");
        yield response.value;
      }
    } catch (e) {
      print("❌ gRPC Stream Error: $e");
      yield "Error: $e";
    }
  }

  Future<void> shutdown() async {
    try {
      await channel.shutdown();
      isConnected = false;
      print("🛑 gRPC Client disconnected.");
    } catch (e) {
      print("⚠️ gRPC shutdown error: $e");
    }
  }
}
