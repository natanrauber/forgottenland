import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'lib/workers/highscores.dart';
import 'lib/workers/online_controller.dart';
import 'lib/workers/scraper.dart';
import 'lib/workers/user.dart';

// Configure routes.
final _router = Router()
  ..post('/login', User().login)
  ..post('/revive', User().revive)
  ..get('/highscores/<world>/<category>/<vocation>/<page>', Highscores().get)
  ..get('/online', OnlineController().getOnlineNow)
  ..get('/onlinetime/<day>', OnlineController().getOnlineTime)
  ..get('/private/exprecord', Scraper().getExpRecord)
  ..get('/private/currentexp', Scraper().getCurrentExp)
  ..get('/private/expgain+today', Scraper().getExpToday)
  ..get('/private/expgain+yesterday', Scraper().getExpLastDay)
  ..get('/private/expgain+last7days', Scraper().getExpLast7Days)
  ..get('/private/expgain+last30days', Scraper().getExpLast30Days)
  ..get('/private/online', OnlineController().registerOnlinePlayers);
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
