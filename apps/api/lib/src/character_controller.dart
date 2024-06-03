import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/src/highscores_controller.dart';
import 'package:forgottenlandapi/utils/error_handler.dart';
import 'package:forgottenlandapi/utils/maps.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

class CharacterController {
  CharacterController(this.env, this.databaseClient, this.httpClient, this.highscoresCtrl) {
    pathTibiaData = env['PATH_TIBIA_DATA'];
  }

  final Env env;
  final IDatabaseClient databaseClient;
  final IHttpClient httpClient;
  final HighscoresController highscoresCtrl;

  String? pathTibiaData;

  Future<Response> get(Request request) async {
    String? name = request.params['name']?.toLowerCase().replaceAll('%20', ' ');
    if (name == null) return ApiResponse.error('Missing param "name"');

    try {
      final MyHttpResponse response = await httpClient.get('$pathTibiaData/character/${name.replaceAll(' ', '%20')}');
      if (_notFound(name, response)) return ApiResponse.notFound();
      if (_notOnRookgaard(response)) return ApiResponse.notAcceptable();
      await _getExpGain(name, response);
      await _getOnlineTime(name, response);
      await _getRookmaster(name, response);
      return ApiResponse.success(data: response.dataAsMap['character']);
    } catch (e) {
      return handleError(e);
    }
  }

  bool _notFound(String name, MyHttpResponse response) =>
      response.dataAsMap['character']['character']['name']?.toString().toLowerCase() != name;

  bool _notOnRookgaard(MyHttpResponse response) =>
      response.dataAsMap['character']['character']['residence']?.toString().toLowerCase() != 'rookgaard';

  Future<void> _getExpGain(String name, MyHttpResponse httpResponse) async {
    httpResponse.dataAsMap['character']['experiencegained'] = <String, dynamic>{};
    List<String> timeframes = <String>['today', 'yesterday', 'last7days', 'last30days', 'last365days'];
    for (String timeframe in timeframes) {
      try {
        final Record? record = await highscoresCtrl.localGetExpGain(
          'all',
          'experiencegained+$timeframe',
          null,
          tableToCategory['experiencegained+$timeframe']!,
          dateToCategory['experiencegained+$timeframe']!,
        );
        if (record == null) return;
        for (HighscoresEntry e in record.list) {
          if (e.name?.toLowerCase() == name) {
            httpResponse.dataAsMap['character']['experiencegained'][timeframe] = e.toJson();
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _getOnlineTime(String name, MyHttpResponse httpResponse) async {
    httpResponse.dataAsMap['character']['onlinetime'] = <String, dynamic>{};
    List<String> timeframes = <String>['today', 'yesterday', 'last7days', 'last30days', 'last365days'];
    for (String timeframe in timeframes) {
      try {
        final Online? online = await highscoresCtrl.localGetOnlineTime(
          'all',
          'onlinetime+$timeframe',
          null,
          tableToCategory['onlinetime+$timeframe']!,
          dateToCategory['onlinetime+$timeframe']!,
        );
        if (online == null) return;
        for (OnlineEntry e in online.list) {
          if (e.name?.toLowerCase() == name) {
            httpResponse.dataAsMap['character']['onlinetime'][timeframe] = e.toJson();
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _getRookmaster(String name, MyHttpResponse httpResponse) async {
    try {
      final Record? record = await highscoresCtrl.localGetRookmaster('All', null);
      if (record == null) return;
      for (HighscoresEntry e in record.list) {
        if (e.name?.toLowerCase() == name) {
          httpResponse.dataAsMap['character']['rookmaster'] = e.toJson();
        }
      }
    } catch (_) {}
  }
}
