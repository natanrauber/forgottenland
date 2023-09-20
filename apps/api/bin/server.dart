import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/src/character_controller.dart';
import 'package:forgottenlandapi/src/highscores_controller.dart';
import 'package:forgottenlandapi/src/online_controller.dart';
import 'package:forgottenlandapi/src/user_controller.dart';
import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

final Env _env = Env();
final IDatabaseClient _databaseClient = MySupabaseClient();
final IHttpClient _httpClient = MyDioClient();

final CharacterController _characterCtrl = CharacterController(_env, _databaseClient, _httpClient, _highscoresCtrl);
final HighscoresController _highscoresCtrl = HighscoresController(_env, _databaseClient, _httpClient);
final OnlineController _onlineCtrl = OnlineController(_databaseClient);
final UserController _userCtrl = UserController(_databaseClient);

// Configure routes.
final _router = Router()
  ..get('/character/<name>', _characterCtrl.get)
  ..get('/highscores/<world>/<category>/<vocation>/<page>', _highscoresCtrl.get)
  ..get('/online/time/<date>', _onlineCtrl.getOnlineTime)
  ..get('/online/now', _onlineCtrl.getOnlineNow)
  ..post('/user/login', _userCtrl.login)
  ..post('/user/revive', _userCtrl.revive);

void main(List<String> args) async {
  _env.log();

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
