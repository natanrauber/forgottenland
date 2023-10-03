import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/src/bazaar_controller.dart';
import 'package:forgottenlandapi/src/character_controller.dart';
import 'package:forgottenlandapi/src/highscores_controller.dart';
import 'package:forgottenlandapi/src/online_controller.dart';
import 'package:forgottenlandapi/src/user_controller.dart';
import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

final List<String> _requiredVar = <String>['PATH_TIBIA_DATA'];
final Env _env = Env();
final IDatabaseClient _databaseClient = MySupabaseClient();
final IHttpClient _httpClient = MyDioClient();

final HighscoresController _highscoresCtrl = HighscoresController(_env, _databaseClient, _httpClient);
final CharacterController _characterCtrl = CharacterController(_env, _databaseClient, _httpClient, _highscoresCtrl);
final IBazaarController _bazaarCtrl = BazaarController(_databaseClient);
final IOnlineController _onlineCtrl = OnlineController(_databaseClient);
final UserController _userCtrl = UserController(_databaseClient);

// Configure routes.
final Router _router = Router()
  ..get('/character/<name>', _characterCtrl.get)
  ..get('/highscores/<world>/<category>/<vocation>/<page>', _highscoresCtrl.get)
  ..get('/online/now', _onlineCtrl.getOnlineNow)
  ..get('/online/time/<date>', _onlineCtrl.getOnlineTime)
  ..get('/bazaar', _bazaarCtrl.get)
  ..post('/user/login', _userCtrl.login)
  ..post('/user/revive', _userCtrl.revive);

void main(List<String> args) async {
  _env.log();
  if (_env.isMissingAny(_requiredVar)) return print('Missing required environment variable');

  // Use any available host or container IP (usually `0.0.0.0`).
  final InternetAddress ip = InternetAddress.anyIPv4;

  // fix CORS
  const Map<String, String> corsHeaders = <String, String>{
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': '*',
  };
  Response? options(Request request) => (request.method == 'OPTIONS') ? Response.ok(null, headers: corsHeaders) : null;
  Response cors(Response response) => response.change(headers: corsHeaders);
  final Middleware fixCORS = createMiddleware(requestHandler: options, responseHandler: cors);

  // Configure a pipeline that logs requests.
  final Handler handler = Pipeline().addMiddleware(fixCORS).addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final int port = int.parse(Platform.environment['PORT'] ?? '8080');
  final HttpServer server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
