import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'generated/google/protobuf/empty.pb.dart';
import 'generated/myservice.pbgrpc.dart';

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
      debugPrint("gRPC Client connected to $host:$port");
    } catch (e) {
      isConnected = false;
      debugPrint("gRPC Client initialization failed: $e");
    }
  }

  Stream<String> streamMessages() async* {
    if (!isConnected) {
      debugPrint("gRPC Client is not connected!");
      yield "Error: Not connected to gRPC server.";
      return;
    }

    try {
      debugPrint("📡 Streaming messages from gRPC server...");
      await for (var response in stub.streamMessages(Empty())) {
        if (response.hasSensorData()) {
          debugPrint("Received: ${response.sensorData}");
          yield response.sensorData.toString();
        } else {
          debugPrint("Received unknown payload.");
          yield "Unknown payload type.";
        }
      }
    } catch (e) {
      debugPrint("gRPC Stream Error: $e");
      yield "Error: $e";
    }
  }

  Future<void> shutdown() async {
    try {
      await channel.shutdown();
      isConnected = false;
      debugPrint("gRPC Client disconnected.");
    } catch (e) {
      debugPrint("gRPC shutdown error: $e");
    }
  }
}
