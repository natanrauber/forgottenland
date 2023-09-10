library env;

import 'dart:io';

import 'package:dotenv/dotenv.dart';

const Map<String, String?> _variables = <String, String?>{
  'PATH_ETL': String.fromEnvironment('PATH_ETL'),
  'DATABASE_URL': String.fromEnvironment('DATABASE_URL'),
  'DATABASE_KEY': String.fromEnvironment('DATABASE_KEY'),
};

class Env {
  Env({bool useEnvFileIfExists = true}) {
    print('Loading environment variables:');
    for (int i = 0; i < _variables.length; i++) {
      String key = _variables.keys.toList()[i];
      _map[key] = _variables[key];
      print('\t[${i + 1}/${_variables.length}] (${_map[key].runtimeType}) (${_map[key]?.length}) $key');
    }
    if (File('./.env').existsSync()) {
      DotEnv? env = DotEnv()..load();
      print('Overwriting environment variables:');
      for (int i = 0; i < _variables.length; i++) {
        String key = _variables.keys.toList()[i];
        _map[key] = env[key];
        print('\t[${i + 1}/${_variables.length}] (${_map[key].runtimeType}) (${_map[key]?.length}) $key');
      }
    }
  }

  final _map = <String, String?>{};

  Map<String, String?> get map => _map;

  String? operator [](String key) => _map[key];
}
