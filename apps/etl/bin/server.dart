import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandetl/src/etl.dart';
import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

final List<String> _requiredVar = ['PATH_TIBIA_DATA'];
final Env _env = Env();
final IDatabaseClient _databaseClient = MySupabaseClient();
final IHttpClient _httpClient = MyDioClient();

// Configure routes.
final _router = Router()
  ..get('/bazaar', ETL(_env, _databaseClient, _httpClient).bazaar)
  ..get('/currentexp', ETL(_env, _databaseClient, _httpClient).currentExp)
  ..get('/expgain+last30days', ETL(_env, _databaseClient, _httpClient).expGainedLast30Days)
  ..get('/expgain+last7days', ETL(_env, _databaseClient, _httpClient).expGainedLast7Days)
  ..get('/expgain+today', ETL(_env, _databaseClient, _httpClient).expGainedToday)
  ..get('/expgain+yesterday', ETL(_env, _databaseClient, _httpClient).expGainedYesterday)
  ..get('/exprecord', ETL(_env, _databaseClient, _httpClient).expRecord)
  ..get('/online', ETL(_env, _databaseClient, _httpClient).registerOnlinePlayers)
  ..get('/rookmaster', ETL(_env, _databaseClient, _httpClient).rookmaster)
  ..get('/skill/<name>/<value>', ETL(_env, _databaseClient, _httpClient).calcSkillPoints);

void main(List<String> args) async {
  _env.log();
  if (_env.isMissingAny(_requiredVar)) return print('Missing required environment variable');

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // fix CORS
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, DELETE, OPTIONS",
    "Access-Control-Allow-Headers": "*",
  };
  Response? options(Request request) => (request.method == "OPTIONS") ? Response.ok(null, headers: corsHeaders) : null;
  Response cors(Response response) => response.change(headers: corsHeaders);
  final fixCORS = createMiddleware(requestHandler: options, responseHandler: cors);

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(fixCORS).addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
