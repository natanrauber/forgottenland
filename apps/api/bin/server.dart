import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/src/etl.dart';
import 'package:forgottenlandapi/src/highscores_controller.dart';
import 'package:forgottenlandapi/src/online_controller.dart';
import 'package:forgottenlandapi/src/user_controller.dart';
import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final IDatabaseClient _databaseClient = MySupabaseClient();
final IHttpClient _httpClient = MyDioClient();

// Configure routes.
final _router = Router()
  ..post('/login', UserController(_databaseClient).login)
  ..post('/revive', UserController(_databaseClient).revive)
  ..get('/highscores/<world>/<category>/<vocation>/<page>', HighscoresController(_databaseClient, _httpClient).get)
  ..get('/online', OnlineController(_databaseClient).getOnlineNow)
  ..get('/onlinetime/<date>', OnlineController(_databaseClient).getOnlineTime)
  ..get('/private/exprecord', ETL(_databaseClient, _httpClient).expRecord)
  ..get('/private/currentexp', ETL(_databaseClient, _httpClient).currentExp)
  ..get('/private/expgain+today', ETL(_databaseClient, _httpClient).expGainedToday)
  ..get('/private/expgain+yesterday', ETL(_databaseClient, _httpClient).expGainedYesterday)
  ..get('/private/expgain+last7days', ETL(_databaseClient, _httpClient).expGainedLast7Days)
  ..get('/private/expgain+last30days', ETL(_databaseClient, _httpClient).expGainedLast30Days)
  ..get('/private/online', ETL(_databaseClient, _httpClient).registerOnlinePlayers);

void main(List<String> args) async {
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
