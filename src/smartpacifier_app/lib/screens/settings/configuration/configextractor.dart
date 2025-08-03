// File: lib/screens/settings/configuration/configextractor.dart

import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

/// Loads and exposes values from config.yml
class ConfigExtractor {
  static late final String host;
  static late final int port;
  /// Call once before runApp (or before you need the values).
  static Future<void> init() async {
    final yamlString = await rootBundle.loadString(
      'lib/screens/settings/configuration/config.yml',
    );
    final doc = loadYaml(yamlString) as YamlMap;
    host = doc['host'] as String;
    port = doc['port'] as int;
  }
}
