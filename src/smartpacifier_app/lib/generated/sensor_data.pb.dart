///
//  Generated code. Do not modify.
//  source: sensor_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SensorData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SensorData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pacifierId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sensorType')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sensorGroup')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sensorPayloadType')
    ..m<$core.String, $core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dataMap', entryClassName: 'SensorData.DataMapEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OY, packageName: const $pb.PackageName('Protos'))
    ..hasRequiredFields = false
  ;

  SensorData._() : super();
  factory SensorData({
    $core.String? pacifierId,
    $core.String? sensorType,
    $core.String? sensorGroup,
    $core.String? sensorPayloadType,
    $core.Map<$core.String, $core.List<$core.int>>? dataMap,
  }) {
    final _result = create();
    if (pacifierId != null) {
      _result.pacifierId = pacifierId;
    }
    if (sensorType != null) {
      _result.sensorType = sensorType;
    }
    if (sensorGroup != null) {
      _result.sensorGroup = sensorGroup;
    }
    if (sensorPayloadType != null) {
      _result.sensorPayloadType = sensorPayloadType;
    }
    if (dataMap != null) {
      _result.dataMap.addAll(dataMap);
    }
    return _result;
  }
  factory SensorData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SensorData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SensorData clone() => SensorData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SensorData copyWith(void Function(SensorData) updates) => super.copyWith((message) => updates(message as SensorData)) as SensorData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SensorData create() => SensorData._();
  SensorData createEmptyInstance() => create();
  static $pb.PbList<SensorData> createRepeated() => $pb.PbList<SensorData>();
  @$core.pragma('dart2js:noInline')
  static SensorData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SensorData>(create);
  static SensorData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pacifierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pacifierId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPacifierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPacifierId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sensorType => $_getSZ(1);
  @$pb.TagNumber(2)
  set sensorType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSensorType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSensorType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sensorGroup => $_getSZ(2);
  @$pb.TagNumber(3)
  set sensorGroup($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSensorGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearSensorGroup() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sensorPayloadType => $_getSZ(3);
  @$pb.TagNumber(4)
  set sensorPayloadType($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSensorPayloadType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSensorPayloadType() => clearField(4);

  @$pb.TagNumber(5)
  $core.Map<$core.String, $core.List<$core.int>> get dataMap => $_getMap(4);
}

class IMUData_Gyro extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData.Gyro', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyroX', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyroY', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyroZ', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  IMUData_Gyro._() : super();
  factory IMUData_Gyro({
    $core.double? gyroX,
    $core.double? gyroY,
    $core.double? gyroZ,
  }) {
    final _result = create();
    if (gyroX != null) {
      _result.gyroX = gyroX;
    }
    if (gyroY != null) {
      _result.gyroY = gyroY;
    }
    if (gyroZ != null) {
      _result.gyroZ = gyroZ;
    }
    return _result;
  }
  factory IMUData_Gyro.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData_Gyro.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData_Gyro clone() => IMUData_Gyro()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData_Gyro copyWith(void Function(IMUData_Gyro) updates) => super.copyWith((message) => updates(message as IMUData_Gyro)) as IMUData_Gyro; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData_Gyro create() => IMUData_Gyro._();
  IMUData_Gyro createEmptyInstance() => create();
  static $pb.PbList<IMUData_Gyro> createRepeated() => $pb.PbList<IMUData_Gyro>();
  @$core.pragma('dart2js:noInline')
  static IMUData_Gyro getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData_Gyro>(create);
  static IMUData_Gyro? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get gyroX => $_getN(0);
  @$pb.TagNumber(1)
  set gyroX($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGyroX() => $_has(0);
  @$pb.TagNumber(1)
  void clearGyroX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get gyroY => $_getN(1);
  @$pb.TagNumber(2)
  set gyroY($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGyroY() => $_has(1);
  @$pb.TagNumber(2)
  void clearGyroY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get gyroZ => $_getN(2);
  @$pb.TagNumber(3)
  set gyroZ($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGyroZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearGyroZ() => clearField(3);
}

class IMUData_Mag extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData.Mag', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'magX', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'magY', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'magZ', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  IMUData_Mag._() : super();
  factory IMUData_Mag({
    $core.double? magX,
    $core.double? magY,
    $core.double? magZ,
  }) {
    final _result = create();
    if (magX != null) {
      _result.magX = magX;
    }
    if (magY != null) {
      _result.magY = magY;
    }
    if (magZ != null) {
      _result.magZ = magZ;
    }
    return _result;
  }
  factory IMUData_Mag.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData_Mag.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData_Mag clone() => IMUData_Mag()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData_Mag copyWith(void Function(IMUData_Mag) updates) => super.copyWith((message) => updates(message as IMUData_Mag)) as IMUData_Mag; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData_Mag create() => IMUData_Mag._();
  IMUData_Mag createEmptyInstance() => create();
  static $pb.PbList<IMUData_Mag> createRepeated() => $pb.PbList<IMUData_Mag>();
  @$core.pragma('dart2js:noInline')
  static IMUData_Mag getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData_Mag>(create);
  static IMUData_Mag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get magX => $_getN(0);
  @$pb.TagNumber(1)
  set magX($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMagX() => $_has(0);
  @$pb.TagNumber(1)
  void clearMagX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get magY => $_getN(1);
  @$pb.TagNumber(2)
  set magY($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMagY() => $_has(1);
  @$pb.TagNumber(2)
  void clearMagY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get magZ => $_getN(2);
  @$pb.TagNumber(3)
  set magZ($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMagZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearMagZ() => clearField(3);
}

class IMUData_Acc extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData.Acc', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accX', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accY', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accZ', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  IMUData_Acc._() : super();
  factory IMUData_Acc({
    $core.double? accX,
    $core.double? accY,
    $core.double? accZ,
  }) {
    final _result = create();
    if (accX != null) {
      _result.accX = accX;
    }
    if (accY != null) {
      _result.accY = accY;
    }
    if (accZ != null) {
      _result.accZ = accZ;
    }
    return _result;
  }
  factory IMUData_Acc.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData_Acc.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData_Acc clone() => IMUData_Acc()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData_Acc copyWith(void Function(IMUData_Acc) updates) => super.copyWith((message) => updates(message as IMUData_Acc)) as IMUData_Acc; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData_Acc create() => IMUData_Acc._();
  IMUData_Acc createEmptyInstance() => create();
  static $pb.PbList<IMUData_Acc> createRepeated() => $pb.PbList<IMUData_Acc>();
  @$core.pragma('dart2js:noInline')
  static IMUData_Acc getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData_Acc>(create);
  static IMUData_Acc? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get accX => $_getN(0);
  @$pb.TagNumber(1)
  set accX($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccX() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get accY => $_getN(1);
  @$pb.TagNumber(2)
  set accY($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccY() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get accZ => $_getN(2);
  @$pb.TagNumber(3)
  set accZ($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccZ() => clearField(3);
}

class IMUData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..pc<IMUData_Gyro>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyros', $pb.PbFieldType.PM, subBuilder: IMUData_Gyro.create)
    ..pc<IMUData_Mag>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mags', $pb.PbFieldType.PM, subBuilder: IMUData_Mag.create)
    ..pc<IMUData_Acc>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accs', $pb.PbFieldType.PM, subBuilder: IMUData_Acc.create)
    ..hasRequiredFields = false
  ;

  IMUData._() : super();
  factory IMUData({
    $core.Iterable<IMUData_Gyro>? gyros,
    $core.Iterable<IMUData_Mag>? mags,
    $core.Iterable<IMUData_Acc>? accs,
  }) {
    final _result = create();
    if (gyros != null) {
      _result.gyros.addAll(gyros);
    }
    if (mags != null) {
      _result.mags.addAll(mags);
    }
    if (accs != null) {
      _result.accs.addAll(accs);
    }
    return _result;
  }
  factory IMUData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData clone() => IMUData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData copyWith(void Function(IMUData) updates) => super.copyWith((message) => updates(message as IMUData)) as IMUData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData create() => IMUData._();
  IMUData createEmptyInstance() => create();
  static $pb.PbList<IMUData> createRepeated() => $pb.PbList<IMUData>();
  @$core.pragma('dart2js:noInline')
  static IMUData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData>(create);
  static IMUData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<IMUData_Gyro> get gyros => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<IMUData_Mag> get mags => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<IMUData_Acc> get accs => $_getList(2);
}

class PPGData_Led extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData.Led', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led1', $pb.PbFieldType.O3, protoName: 'led_1')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led2', $pb.PbFieldType.O3, protoName: 'led_2')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led3', $pb.PbFieldType.O3, protoName: 'led_3')
    ..hasRequiredFields = false
  ;

  PPGData_Led._() : super();
  factory PPGData_Led({
    $core.int? led1,
    $core.int? led2,
    $core.int? led3,
  }) {
    final _result = create();
    if (led1 != null) {
      _result.led1 = led1;
    }
    if (led2 != null) {
      _result.led2 = led2;
    }
    if (led3 != null) {
      _result.led3 = led3;
    }
    return _result;
  }
  factory PPGData_Led.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData_Led.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData_Led clone() => PPGData_Led()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData_Led copyWith(void Function(PPGData_Led) updates) => super.copyWith((message) => updates(message as PPGData_Led)) as PPGData_Led; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData_Led create() => PPGData_Led._();
  PPGData_Led createEmptyInstance() => create();
  static $pb.PbList<PPGData_Led> createRepeated() => $pb.PbList<PPGData_Led>();
  @$core.pragma('dart2js:noInline')
  static PPGData_Led getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData_Led>(create);
  static PPGData_Led? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get led1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set led1($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLed1() => $_has(0);
  @$pb.TagNumber(1)
  void clearLed1() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get led2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set led2($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLed2() => $_has(1);
  @$pb.TagNumber(2)
  void clearLed2() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get led3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set led3($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLed3() => $_has(2);
  @$pb.TagNumber(3)
  void clearLed3() => clearField(3);
}

class PPGData_Temperature extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData.Temperature', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  PPGData_Temperature._() : super();
  factory PPGData_Temperature({
    $core.double? temperature,
  }) {
    final _result = create();
    if (temperature != null) {
      _result.temperature = temperature;
    }
    return _result;
  }
  factory PPGData_Temperature.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData_Temperature.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData_Temperature clone() => PPGData_Temperature()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData_Temperature copyWith(void Function(PPGData_Temperature) updates) => super.copyWith((message) => updates(message as PPGData_Temperature)) as PPGData_Temperature; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData_Temperature create() => PPGData_Temperature._();
  PPGData_Temperature createEmptyInstance() => create();
  static $pb.PbList<PPGData_Temperature> createRepeated() => $pb.PbList<PPGData_Temperature>();
  @$core.pragma('dart2js:noInline')
  static PPGData_Temperature getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData_Temperature>(create);
  static PPGData_Temperature? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get temperature => $_getN(0);
  @$pb.TagNumber(1)
  set temperature($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemperature() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperature() => clearField(1);
}

class PPGData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..pc<PPGData_Led>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'leds', $pb.PbFieldType.PM, subBuilder: PPGData_Led.create)
    ..pc<PPGData_Temperature>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperatures', $pb.PbFieldType.PM, subBuilder: PPGData_Temperature.create)
    ..hasRequiredFields = false
  ;

  PPGData._() : super();
  factory PPGData({
    $core.Iterable<PPGData_Led>? leds,
    $core.Iterable<PPGData_Temperature>? temperatures,
  }) {
    final _result = create();
    if (leds != null) {
      _result.leds.addAll(leds);
    }
    if (temperatures != null) {
      _result.temperatures.addAll(temperatures);
    }
    return _result;
  }
  factory PPGData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData clone() => PPGData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData copyWith(void Function(PPGData) updates) => super.copyWith((message) => updates(message as PPGData)) as PPGData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData create() => PPGData._();
  PPGData createEmptyInstance() => create();
  static $pb.PbList<PPGData> createRepeated() => $pb.PbList<PPGData>();
  @$core.pragma('dart2js:noInline')
  static PPGData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData>(create);
  static PPGData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PPGData_Led> get leds => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<PPGData_Temperature> get temperatures => $_getList(1);
}

