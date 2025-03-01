import 'dart:async';
import 'package:flutter/material.dart';
import 'nng_client.dart';
import 'package:ffi/ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter + C++ Pub/Sub')),
        body: Center(child: MessageSubscriber()),
      ),
    );
  }
}

class MessageSubscriber extends StatefulWidget {
  const MessageSubscriber({super.key});

  @override
  State<MessageSubscriber> createState() => _MessageSubscriberState();
}

class _MessageSubscriberState extends State<MessageSubscriber> {
  String _message = 'Waiting for messages...';
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Start the subscriber: "ipc:///tmp/nng.ipc" is the address of the publisher.
    final Pointer<Utf8> urlPtr = "ipc:///tmp/nng.ipc".toNativeUtf8();
    nngSubscribeStart(urlPtr);
    calloc.free(urlPtr);

    // Poll for new messages every 500ms.
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final Pointer<Utf8> msgPtr = nngGetMessage();
      if (msgPtr.address != 0 && msgPtr.toDartString().isNotEmpty) {
        setState(() {
          _message = msgPtr.toDartString();
        });
        nngFreeMessage(msgPtr);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    nngSubscribeStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _message,
      style: const TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
    );
  }
}
