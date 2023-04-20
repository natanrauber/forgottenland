import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:forgottenlandapi/utils/paths.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

class Highscores {
  Future<Response> get(Request request) async {
    String? world = request.params['world'];
    String? category = request.params['category'];
    String? vocation = request.params['vocation'];
    int page = int.tryParse(request.params['page'] ?? '') ?? 1;

    MyHttpResponse? response;
    Record record;

    if (category != null && category.contains('experiencegained')) return _getExpGain(category, page);
    if (category != null && category.contains('onlinetime')) return _getOnlineTime(category, page);

    try {
      response = await MyHttpClient().get('${PATH.tibiaDataApi}/highscores/$world/$category/$vocation/$page');
      record = Record.fromJson((response.dataAsMap['highscores'] as Map<String, dynamic>?) ?? <String, dynamic>{});
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess(data: record.toJson());
  }

  Future<Response> _getExpGain(String category, int page) async {
    dynamic response;
    Record record;

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
      response = await DatabaseClient().from(table).select().eq('date', date).single();
      record = Record.fromJson((response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{});

      if ((page - 1) * 50 > record.list.length) {
        record.list = [];
      } else {
        int start = (page - 1) * 50;
        int end = page * 50;
        if (start < 0) start = 0;
        if (end > record.list.length + 1) end = record.list.length;
        record.list = record.list.getRange(start, end).toList();
      }
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess(data: record.toJson());
  }

  Future<Response> _getOnlineTime(String category, int page) async {
    dynamic response;
    Online online;

    Map<String, String> date = <String, String>{
      'onlinetime+today': MyDateTime.today(),
      'onlinetime+yesterday': MyDateTime.yesterday(),
    };

    try {
      response = await DatabaseClient().from('online-time').select().eq('day', date[category]).single();
      online = Online.fromJson((response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{});

      if ((page - 1) * 50 > online.list.length) {
        online.list = [];
      } else {
        int start = (page - 1) * 50;
        int end = page * 50;
        if (start < 0) start = 0;
        if (end > online.list.length + 1) end = online.list.length;
        online.list = online.list.getRange(start, end).toList();
      }
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess(data: online.toJson());
  }
}
