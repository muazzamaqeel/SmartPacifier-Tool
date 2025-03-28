///
//  Generated code. Do not modify.
//  source: myservice.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'google/protobuf/empty.pb.dart' as $0;
import 'myservice.pb.dart' as $1;
export 'myservice.pb.dart';

class MyServiceClient extends $grpc.Client {
  static final _$streamMessages =
      $grpc.ClientMethod<$0.Empty, $1.PayloadMessage>(
          '/myservice.MyService/StreamMessages',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.PayloadMessage.fromBuffer(value));

  MyServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$1.PayloadMessage> streamMessages($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$streamMessages, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class MyServiceBase extends $grpc.Service {
  $core.String get $name => 'myservice.MyService';

  MyServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.PayloadMessage>(
        'StreamMessages',
        streamMessages_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.PayloadMessage value) => value.writeToBuffer()));
  }

  $async.Stream<$1.PayloadMessage> streamMessages_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* streamMessages(call, await request);
  }

  $async.Stream<$1.PayloadMessage> streamMessages(
      $grpc.ServiceCall call, $0.Empty request);
}
