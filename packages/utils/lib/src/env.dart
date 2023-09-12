library env;

import 'dart:io';

import 'package:dotenv/dotenv.dart';

const Map<String, String?> _variables = <String, String?>{
  'DATABASE_KEY': String.fromEnvironment('DATABASE_KEY'),
  'DATABASE_URL': String.fromEnvironment('DATABASE_URL'),
  'PATH_ETL': String.fromEnvironment('PATH_ETL'),
  'PATH_TIBIA_DATA': String.fromEnvironment('PATH_TIBIA_DATA'),
};

class Env {
  Env({bool useEnvFileIfExists = true}) {
    DotEnv? env;
    if (File('./.env').existsSync()) env = DotEnv()..load();
    for (int i = 0; i < _variables.length; i++) {
      String key = _variables.keys.toList()[i];
      _map[key] = _variables[key];
      if (env != null) _map[key] = env[key];
    }
  }

  final _map = <String, String?>{};

  Map<String, String?> get map => _map;

  String? operator [](String key) => _map[key];

  void log() {
    print('Environment variables:');
    var setEvs = '\tSet:';
    var notSetEvs = '\tNot set:';

    for (final String key in _map.keys) {
      if (_map[key] != null && _map[key] != '') {
        setEvs = '$setEvs $key;';
      } else {
        notSetEvs = '$notSetEvs $key;';
      }
    }

    print(setEvs);
    print(notSetEvs);
  }
}
