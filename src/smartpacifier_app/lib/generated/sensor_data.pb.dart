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
    ..m<$core.String, $core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dataMap', entryClassName: 'SensorData.DataMapEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OY, packageName: const $pb.PackageName('Protos'))
    ..hasRequiredFields = false
  ;

  SensorData._() : super();
  factory SensorData({
    $core.String? pacifierId,
    $core.String? sensorType,
    $core.String? sensorGroup,
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
  $core.Map<$core.String, $core.List<$core.int>> get dataMap => $_getMap(3);
}

class IMUData_gyro extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData.gyro', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyroX', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyroY', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyroZ', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  IMUData_gyro._() : super();
  factory IMUData_gyro({
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
  factory IMUData_gyro.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData_gyro.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData_gyro clone() => IMUData_gyro()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData_gyro copyWith(void Function(IMUData_gyro) updates) => super.copyWith((message) => updates(message as IMUData_gyro)) as IMUData_gyro; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData_gyro create() => IMUData_gyro._();
  IMUData_gyro createEmptyInstance() => create();
  static $pb.PbList<IMUData_gyro> createRepeated() => $pb.PbList<IMUData_gyro>();
  @$core.pragma('dart2js:noInline')
  static IMUData_gyro getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData_gyro>(create);
  static IMUData_gyro? _defaultInstance;

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

class IMUData_mag extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData.mag', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'magX', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'magY', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'magZ', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  IMUData_mag._() : super();
  factory IMUData_mag({
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
  factory IMUData_mag.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData_mag.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData_mag clone() => IMUData_mag()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData_mag copyWith(void Function(IMUData_mag) updates) => super.copyWith((message) => updates(message as IMUData_mag)) as IMUData_mag; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData_mag create() => IMUData_mag._();
  IMUData_mag createEmptyInstance() => create();
  static $pb.PbList<IMUData_mag> createRepeated() => $pb.PbList<IMUData_mag>();
  @$core.pragma('dart2js:noInline')
  static IMUData_mag getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData_mag>(create);
  static IMUData_mag? _defaultInstance;

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

class IMUData_acc extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IMUData.acc', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accX', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accY', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accZ', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  IMUData_acc._() : super();
  factory IMUData_acc({
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
  factory IMUData_acc.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IMUData_acc.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IMUData_acc clone() => IMUData_acc()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IMUData_acc copyWith(void Function(IMUData_acc) updates) => super.copyWith((message) => updates(message as IMUData_acc)) as IMUData_acc; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IMUData_acc create() => IMUData_acc._();
  IMUData_acc createEmptyInstance() => create();
  static $pb.PbList<IMUData_acc> createRepeated() => $pb.PbList<IMUData_acc>();
  @$core.pragma('dart2js:noInline')
  static IMUData_acc getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IMUData_acc>(create);
  static IMUData_acc? _defaultInstance;

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
    ..pc<IMUData_gyro>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gyros', $pb.PbFieldType.PM, subBuilder: IMUData_gyro.create)
    ..pc<IMUData_mag>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mags', $pb.PbFieldType.PM, subBuilder: IMUData_mag.create)
    ..pc<IMUData_acc>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accs', $pb.PbFieldType.PM, subBuilder: IMUData_acc.create)
    ..hasRequiredFields = false
  ;

  IMUData._() : super();
  factory IMUData({
    $core.Iterable<IMUData_gyro>? gyros,
    $core.Iterable<IMUData_mag>? mags,
    $core.Iterable<IMUData_acc>? accs,
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
  $core.List<IMUData_gyro> get gyros => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<IMUData_mag> get mags => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<IMUData_acc> get accs => $_getList(2);
}

class PPGData_led extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData.led', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led1', $pb.PbFieldType.O3, protoName: 'led_1')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led2', $pb.PbFieldType.O3, protoName: 'led_2')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'led3', $pb.PbFieldType.O3, protoName: 'led_3')
    ..hasRequiredFields = false
  ;

  PPGData_led._() : super();
  factory PPGData_led({
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
  factory PPGData_led.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData_led.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData_led clone() => PPGData_led()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData_led copyWith(void Function(PPGData_led) updates) => super.copyWith((message) => updates(message as PPGData_led)) as PPGData_led; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData_led create() => PPGData_led._();
  PPGData_led createEmptyInstance() => create();
  static $pb.PbList<PPGData_led> createRepeated() => $pb.PbList<PPGData_led>();
  @$core.pragma('dart2js:noInline')
  static PPGData_led getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData_led>(create);
  static PPGData_led? _defaultInstance;

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

class PPGData_temperature extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData.temperature', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature1', $pb.PbFieldType.OF, protoName: 'temperature_1')
    ..hasRequiredFields = false
  ;

  PPGData_temperature._() : super();
  factory PPGData_temperature({
    $core.double? temperature1,
  }) {
    final _result = create();
    if (temperature1 != null) {
      _result.temperature1 = temperature1;
    }
    return _result;
  }
  factory PPGData_temperature.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PPGData_temperature.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PPGData_temperature clone() => PPGData_temperature()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PPGData_temperature copyWith(void Function(PPGData_temperature) updates) => super.copyWith((message) => updates(message as PPGData_temperature)) as PPGData_temperature; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PPGData_temperature create() => PPGData_temperature._();
  PPGData_temperature createEmptyInstance() => create();
  static $pb.PbList<PPGData_temperature> createRepeated() => $pb.PbList<PPGData_temperature>();
  @$core.pragma('dart2js:noInline')
  static PPGData_temperature getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PPGData_temperature>(create);
  static PPGData_temperature? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get temperature1 => $_getN(0);
  @$pb.TagNumber(1)
  set temperature1($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemperature1() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperature1() => clearField(1);
}

class PPGData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PPGData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Protos'), createEmptyInstance: create)
    ..pc<PPGData_led>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'leds', $pb.PbFieldType.PM, subBuilder: PPGData_led.create)
    ..pc<PPGData_temperature>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperatures', $pb.PbFieldType.PM, subBuilder: PPGData_temperature.create)
    ..hasRequiredFields = false
  ;

  PPGData._() : super();
  factory PPGData({
    $core.Iterable<PPGData_led>? leds,
    $core.Iterable<PPGData_temperature>? temperatures,
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
  $core.List<PPGData_led> get leds => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<PPGData_temperature> get temperatures => $_getList(1);
}

