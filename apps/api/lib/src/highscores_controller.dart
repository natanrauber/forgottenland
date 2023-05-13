import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:forgottenlandapi/utils/paths.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

class HighscoresController {
  HighscoresController(this.databaseClient, this.httpClient);

  final IDatabaseClient databaseClient;
  final IHttpClient httpClient;

  Future<Response> get(Request request) async {
    String? world = request.params['world'];
    String? category = request.params['category'];
    String? vocation = request.params['vocation'];
    int page = int.tryParse(request.params['page'] ?? '') ?? 1;

    if (category == null) return ApiResponseError('Missing param "category"');
    if (category.contains('experiencegained')) return _getExpGain(category, page);
    if (category.contains('onlinetime')) return _getOnlineTime(category, page);
    if (category.contains('rookmaster')) return _getRookmaster(page);

    try {
      var response = await httpClient.get('${PATH.tibiaDataApi}/highscores/$world/$category/$vocation/$page');
      var record = Record.fromJson(response.dataAsMap['highscores'] as Map<String, dynamic>);
      return ApiResponseSuccess(data: record.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  Future<Response> _getExpGain(String category, int page) async {
    if (page < 0) return ApiResponseError('Invalid page number');

    Map<String, String> tables = <String, String>{
      'experiencegained+today': 'exp-gain-today',
      'experiencegained+yesterday': 'exp-gain-last-day',
      'experiencegained+last7days': 'exp-gain-last-7-days',
      'experiencegained+last30days': 'exp-gain-last-30-days',
    };

    Map<String, String> dates = <String, String>{
      'experiencegained+today': MyDateTime.today(),
      'experiencegained+yesterday': MyDateTime.yesterday(),
      'experiencegained+last7days': MyDateTime.yesterday(),
      'experiencegained+last30days': MyDateTime.yesterday(),
    };

    String table = tables[category] ?? '';
    String date = dates[category] ?? '';

    try {
      var response = await databaseClient.from(table).select().eq('date', date).single();
      var record = Record.fromJson(response['data'] as Map<String, dynamic>);

      if ((page - 1) * 50 > record.list.length) {
        record.list = [];
      } else if (record.list.length > 50) {
        int start = (page - 1) * 50;
        int end = page * 50;
        if (end > record.list.length) end = record.list.length;
        record.list = record.list.getRange(start, end).toList();
      }

      _recordAddMissingRank(record, page);
      return ApiResponseSuccess(data: record.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  void _recordAddMissingRank(Record record, int page) {
    if (record.list.first.rank != null) return;
    int offset = 50 * (page - 1);
    for (var e in record.list) {
      e.rank = record.list.indexOf(e) + 1 + offset;
    }
  }

  Future<Response> _getOnlineTime(String category, int page) async {
    if (page < 0) return ApiResponseError('Invalid page number');

    Map<String, String> tables = <String, String>{
      'onlinetime+today': 'onlinetime',
      'onlinetime+yesterday': 'onlinetime',
      'onlinetime+last7days': 'onlinetime-last7days',
    };

    Map<String, String> dates = <String, String>{
      'onlinetime+today': MyDateTime.today(),
      'onlinetime+yesterday': MyDateTime.yesterday(),
      'onlinetime+last7days': MyDateTime.yesterday(),
      'onlinetime+last30days': MyDateTime.yesterday(),
    };

    String table = tables[category] ?? '';
    String date = dates[category] ?? '';

    try {
      var response = await databaseClient.from(table).select().eq('date', date).single();
      var online = Online.fromJson(response['data'] as Map<String, dynamic>);

      if ((page - 1) * 50 > online.list.length) {
        online.list = [];
      } else {
        int start = (page - 1) * 50;
        int end = page * 50;
        if (end > online.list.length) end = online.list.length;
        online.list = online.list.getRange(start, end).toList();
      }

      _onlineAddMissingRank(online, page);
      return ApiResponseSuccess(data: online.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  void _onlineAddMissingRank(Online online, int page) {
    if (online.list.first.rank != null) return;
    int offset = 50 * (page - 1);
    for (var e in online.list) {
      e.rank = online.list.indexOf(e) + 1 + offset;
    }
  }

  Future<Response> _getRookmaster(int page) async {
    if (page < 0) return ApiResponseError('Invalid page number');

    try {
      var response = await databaseClient.from('rook-master').select().eq('date', MyDateTime.today()).single();
      var record = Record.fromJson(response['data'] as Map<String, dynamic>);

      if ((page - 1) * 50 > record.list.length) {
        record.list = [];
      } else if (record.list.length > 50) {
        int start = (page - 1) * 50;
        int end = page * 50;
        if (end > record.list.length) end = record.list.length;
        record.list = record.list.getRange(start, end).toList();
      }

      _recordAddMissingRank(record, page);
      return ApiResponseSuccess(data: record.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  Future<Response> rookmaster(Request request) async {
    try {
      var response = await databaseClient.from('rook-master').select().limit(1).single();
      var record = Record.fromJsonExpanded(response['data'] as Map<String, dynamic>);
      return ApiResponseSuccess(data: record.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }
}
