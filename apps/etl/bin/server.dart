import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandetl/src/etl.dart';
import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

final List<String> _requiredVar = ['PATH_TIBIA_DATA'];
final Env _env = Env();
final IDatabaseClient _databaseClient = MySupabaseClient();
final IHttpClient _httpClient = MyDioClient();

// Configure routes.
final _router = Router()
  ..get('/exprecord', ETL(_env, _databaseClient, _httpClient).expRecord)
  ..get('/currentexp', ETL(_env, _databaseClient, _httpClient).currentExp)
  ..get('/expgain+today', ETL(_env, _databaseClient, _httpClient).expGainedToday)
  ..get('/expgain+yesterday', ETL(_env, _databaseClient, _httpClient).expGainedYesterday)
  ..get('/expgain+last7days', ETL(_env, _databaseClient, _httpClient).expGainedLast7Days)
  ..get('/expgain+last30days', ETL(_env, _databaseClient, _httpClient).expGainedLast30Days)
  ..get('/expgain+last365days', ETL(_env, _databaseClient, _httpClient).expGainedLast365Days)
  ..get('/online', ETL(_env, _databaseClient, _httpClient).registerOnlinePlayers)
  ..get('/rookmaster', ETL(_env, _databaseClient, _httpClient).rookmaster)
  ..get('/skill/<name>/<value>', ETL(_env, _databaseClient, _httpClient).calcSkillPoints);

void main(List<String> args) async {
  // _env.log();
  if (_env.isMissingAny(_requiredVar)) return print('Missing required environment variable');

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final Handler handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
