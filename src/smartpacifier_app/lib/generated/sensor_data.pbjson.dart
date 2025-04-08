///
//  Generated code. Do not modify.
//  source: sensor_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use sensorDataDescriptor instead')
const SensorData$json = const {
  '1': 'SensorData',
  '2': const [
    const {'1': 'pacifier_id', '3': 1, '4': 1, '5': 9, '10': 'pacifierId'},
    const {'1': 'sensor_type', '3': 2, '4': 1, '5': 9, '10': 'sensorType'},
    const {'1': 'sensor_group', '3': 3, '4': 1, '5': 9, '10': 'sensorGroup'},
    const {'1': 'sensor_payload_type', '3': 4, '4': 1, '5': 9, '10': 'sensorPayloadType'},
    const {'1': 'data_map', '3': 5, '4': 3, '5': 11, '6': '.Protos.SensorData.DataMapEntry', '10': 'dataMap'},
  ],
  '3': const [SensorData_DataMapEntry$json],
};

@$core.Deprecated('Use sensorDataDescriptor instead')
const SensorData_DataMapEntry$json = const {
  '1': 'DataMapEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `SensorData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorDataDescriptor = $convert.base64Decode('CgpTZW5zb3JEYXRhEh8KC3BhY2lmaWVyX2lkGAEgASgJUgpwYWNpZmllcklkEh8KC3NlbnNvcl90eXBlGAIgASgJUgpzZW5zb3JUeXBlEiEKDHNlbnNvcl9ncm91cBgDIAEoCVILc2Vuc29yR3JvdXASLgoTc2Vuc29yX3BheWxvYWRfdHlwZRgEIAEoCVIRc2Vuc29yUGF5bG9hZFR5cGUSOgoIZGF0YV9tYXAYBSADKAsyHy5Qcm90b3MuU2Vuc29yRGF0YS5EYXRhTWFwRW50cnlSB2RhdGFNYXAaOgoMRGF0YU1hcEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgMUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use iMUDataDescriptor instead')
const IMUData$json = const {
  '1': 'IMUData',
  '2': const [
    const {'1': 'gyros', '3': 1, '4': 3, '5': 11, '6': '.Protos.IMUData.Gyro', '10': 'gyros'},
    const {'1': 'mags', '3': 2, '4': 3, '5': 11, '6': '.Protos.IMUData.Mag', '10': 'mags'},
    const {'1': 'accs', '3': 3, '4': 3, '5': 11, '6': '.Protos.IMUData.Acc', '10': 'accs'},
  ],
  '3': const [IMUData_Gyro$json, IMUData_Mag$json, IMUData_Acc$json],
};

@$core.Deprecated('Use iMUDataDescriptor instead')
const IMUData_Gyro$json = const {
  '1': 'Gyro',
  '2': const [
    const {'1': 'gyro_x', '3': 1, '4': 1, '5': 2, '10': 'gyroX'},
    const {'1': 'gyro_y', '3': 2, '4': 1, '5': 2, '10': 'gyroY'},
    const {'1': 'gyro_z', '3': 3, '4': 1, '5': 2, '10': 'gyroZ'},
  ],
};

@$core.Deprecated('Use iMUDataDescriptor instead')
const IMUData_Mag$json = const {
  '1': 'Mag',
  '2': const [
    const {'1': 'mag_x', '3': 1, '4': 1, '5': 2, '10': 'magX'},
    const {'1': 'mag_y', '3': 2, '4': 1, '5': 2, '10': 'magY'},
    const {'1': 'mag_z', '3': 3, '4': 1, '5': 2, '10': 'magZ'},
  ],
};

@$core.Deprecated('Use iMUDataDescriptor instead')
const IMUData_Acc$json = const {
  '1': 'Acc',
  '2': const [
    const {'1': 'acc_x', '3': 1, '4': 1, '5': 2, '10': 'accX'},
    const {'1': 'acc_y', '3': 2, '4': 1, '5': 2, '10': 'accY'},
    const {'1': 'acc_z', '3': 3, '4': 1, '5': 2, '10': 'accZ'},
  ],
};

/// Descriptor for `IMUData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iMUDataDescriptor = $convert.base64Decode('CgdJTVVEYXRhEioKBWd5cm9zGAEgAygLMhQuUHJvdG9zLklNVURhdGEuR3lyb1IFZ3lyb3MSJwoEbWFncxgCIAMoCzITLlByb3Rvcy5JTVVEYXRhLk1hZ1IEbWFncxInCgRhY2NzGAMgAygLMhMuUHJvdG9zLklNVURhdGEuQWNjUgRhY2NzGksKBEd5cm8SFQoGZ3lyb194GAEgASgCUgVneXJvWBIVCgZneXJvX3kYAiABKAJSBWd5cm9ZEhUKBmd5cm9fehgDIAEoAlIFZ3lyb1oaRAoDTWFnEhMKBW1hZ194GAEgASgCUgRtYWdYEhMKBW1hZ195GAIgASgCUgRtYWdZEhMKBW1hZ196GAMgASgCUgRtYWdaGkQKA0FjYxITCgVhY2NfeBgBIAEoAlIEYWNjWBITCgVhY2NfeRgCIAEoAlIEYWNjWRITCgVhY2NfehgDIAEoAlIEYWNjWg==');
@$core.Deprecated('Use pPGDataDescriptor instead')
const PPGData$json = const {
  '1': 'PPGData',
  '2': const [
    const {'1': 'leds', '3': 1, '4': 3, '5': 11, '6': '.Protos.PPGData.Led', '10': 'leds'},
    const {'1': 'temperatures', '3': 2, '4': 3, '5': 11, '6': '.Protos.PPGData.Temperature', '10': 'temperatures'},
  ],
  '3': const [PPGData_Led$json, PPGData_Temperature$json],
};

@$core.Deprecated('Use pPGDataDescriptor instead')
const PPGData_Led$json = const {
  '1': 'Led',
  '2': const [
    const {'1': 'led_1', '3': 1, '4': 1, '5': 5, '10': 'led1'},
    const {'1': 'led_2', '3': 2, '4': 1, '5': 5, '10': 'led2'},
    const {'1': 'led_3', '3': 3, '4': 1, '5': 5, '10': 'led3'},
  ],
};

@$core.Deprecated('Use pPGDataDescriptor instead')
const PPGData_Temperature$json = const {
  '1': 'Temperature',
  '2': const [
    const {'1': 'temperature', '3': 1, '4': 1, '5': 2, '10': 'temperature'},
  ],
};

/// Descriptor for `PPGData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pPGDataDescriptor = $convert.base64Decode('CgdQUEdEYXRhEicKBGxlZHMYASADKAsyEy5Qcm90b3MuUFBHRGF0YS5MZWRSBGxlZHMSPwoMdGVtcGVyYXR1cmVzGAIgAygLMhsuUHJvdG9zLlBQR0RhdGEuVGVtcGVyYXR1cmVSDHRlbXBlcmF0dXJlcxpECgNMZWQSEwoFbGVkXzEYASABKAVSBGxlZDESEwoFbGVkXzIYAiABKAVSBGxlZDISEwoFbGVkXzMYAyABKAVSBGxlZDMaLwoLVGVtcGVyYXR1cmUSIAoLdGVtcGVyYXR1cmUYASABKAJSC3RlbXBlcmF0dXJl');
