import 'dart:convert';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/src/highscores_controller.dart';
import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:forgottenlandapi/utils/error_handler.dart';
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

    if (name == null) return ApiResponseError('Missing param "name"');

    try {
      final MyHttpResponse response = await httpClient.get('$pathTibiaData/character/$name');
      await _getExpGain(name, response);
      return ApiResponseSuccess(data: response.dataAsMap['characters']);
    } catch (e) {
      return handleError(e);
    }
  }

  Future<void> _getExpGain(String name, MyHttpResponse httpResponse) async {
    httpResponse.dataAsMap['characters']['experiencegained'] = <String, dynamic>{};

    List<String> timeframes = <String>[
      'today',
      'yesterday',
      'last7days',
      'last30days',
    ];

    for (String timeframe in timeframes) {
      Response response = await highscoresCtrl.getExpGain('all', 'experiencegained+$timeframe', null);
      Map<String, dynamic> data = jsonDecode(await (response).readAsString());
      final Record record = Record.fromJson(data['data'] as Map<String, dynamic>);
      for (HighscoresEntry e in record.list) {
        if (e.name?.toLowerCase() == name) {
          httpResponse.dataAsMap['characters']['experiencegained'][timeframe] = <String, dynamic>{
            'rank': record.list.indexOf(e) + 1,
            'value': e.value,
          };
        }
      }
    }
  }
}
