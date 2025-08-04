///
//  Generated code. Do not modify.
//  source: myservice.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'myservice.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'myservice.pb.dart';

class MyServiceClient extends $grpc.Client {
  static final _$publishSensorData =
      $grpc.ClientMethod<$0.PayloadMessage, $1.Empty>(
          '/myservice.MyService/PublishSensorData',
          ($0.PayloadMessage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  MyServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> publishSensorData(
      $async.Stream<$0.PayloadMessage> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$publishSensorData, request, options: options)
        .single;
  }
}

abstract class MyServiceBase extends $grpc.Service {
  $core.String get $name => 'myservice.MyService';

  MyServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PayloadMessage, $1.Empty>(
        'PublishSensorData',
        publishSensorData,
        true,
        false,
        ($core.List<$core.int> value) => $0.PayloadMessage.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> publishSensorData(
      $grpc.ServiceCall call, $async.Stream<$0.PayloadMessage> request);
}
