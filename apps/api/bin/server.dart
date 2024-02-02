import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/src/bazaar_controller.dart';
import 'package:forgottenlandapi/src/books_controller.dart';
import 'package:forgottenlandapi/src/character_controller.dart';
import 'package:forgottenlandapi/src/highscores_controller.dart';
import 'package:forgottenlandapi/src/live_streams_controller.dart';
import 'package:forgottenlandapi/src/npcs_controller.dart';
import 'package:forgottenlandapi/src/online_controller.dart';
import 'package:forgottenlandapi/src/settings_controller.dart';
import 'package:forgottenlandapi/src/user_controller.dart';
import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

final List<String> _requiredVar = <String>['PATH_TIBIA_DATA'];
final Env _env = Env();
final IDatabaseClient _databaseClient = MySupabaseClient();
final IHttpClient _httpClient = MyDioClient();

final CharacterController _characterCtrl = CharacterController(_env, _databaseClient, _httpClient, _highscoresCtrl);
final HighscoresController _highscoresCtrl = HighscoresController(_env, _databaseClient, _httpClient);
final IBazaarController _bazaarCtrl = BazaarController(_databaseClient);
final IBooksController _booksCtrl = BooksController(_httpClient);
final ILiveStreamsController _liveStreamsCtrl = LiveStreamsController(_databaseClient, _httpClient);
final INPCsController _npcsCtrl = NPCsController(_httpClient);
final IOnlineController _onlineCtrl = OnlineController(_databaseClient);
final SettingsController _settingsCtrl = SettingsController(_databaseClient);
final UserController _userCtrl = UserController(_databaseClient);

// Configure routes.
final Router _router = Router()
  ..get('/bazaar', _bazaarCtrl.get)
  ..get('/npcs', _npcsCtrl.getAll)
  ..get('/npc/transcripts/<name>', _npcsCtrl.getTranscripts)
  ..get('/books', _booksCtrl.getAll)
  ..get('/character/<name>', _characterCtrl.get)
  ..get('/highscores/<world>/<category>/<vocation>/<page>', _highscoresCtrl.get)
  ..get('/livestreams', _liveStreamsCtrl.get)
  ..get('/online/now', _onlineCtrl.getOnlineNow)
  ..get('/online/time/<date>', _onlineCtrl.getOnlineTime)
  ..get('/settings/<value>', _settingsCtrl.get)
  ..post('/user/login', _userCtrl.login)
  ..post('/user/revive', _userCtrl.revive);

void main(List<String> args) async {
  _env.log();
  if (_env.isMissingAny(_requiredVar)) return print('Missing required environment variable');

  // Use any available host or container IP (usually `0.0.0.0`).
  final InternetAddress ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final Handler handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final int port = int.parse(Platform.environment['PORT'] ?? '8080');
  final HttpServer server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
