///
//  Generated code. Do not modify.
//  source: myservice.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'sensor_data.pb.dart' as $2;

enum PayloadMessage_Payload {
  sensorData, 
  notSet
}

class PayloadMessage extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, PayloadMessage_Payload> _PayloadMessage_PayloadByTag = {
    1 : PayloadMessage_Payload.sensorData,
    0 : PayloadMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PayloadMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'myservice'), createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<$2.SensorData>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sensorData', subBuilder: $2.SensorData.create)
    ..hasRequiredFields = false
  ;

  PayloadMessage._() : super();
  factory PayloadMessage({
    $2.SensorData? sensorData,
  }) {
    final _result = create();
    if (sensorData != null) {
      _result.sensorData = sensorData;
    }
    return _result;
  }
  factory PayloadMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PayloadMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PayloadMessage clone() => PayloadMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PayloadMessage copyWith(void Function(PayloadMessage) updates) => super.copyWith((message) => updates(message as PayloadMessage)) as PayloadMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PayloadMessage create() => PayloadMessage._();
  PayloadMessage createEmptyInstance() => create();
  static $pb.PbList<PayloadMessage> createRepeated() => $pb.PbList<PayloadMessage>();
  @$core.pragma('dart2js:noInline')
  static PayloadMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PayloadMessage>(create);
  static PayloadMessage? _defaultInstance;

  PayloadMessage_Payload whichPayload() => _PayloadMessage_PayloadByTag[$_whichOneof(0)]!;
  void clearPayload() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $2.SensorData get sensorData => $_getN(0);
  @$pb.TagNumber(1)
  set sensorData($2.SensorData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSensorData() => $_has(0);
  @$pb.TagNumber(1)
  void clearSensorData() => clearField(1);
  @$pb.TagNumber(1)
  $2.SensorData ensureSensorData() => $_ensure(0);
}

