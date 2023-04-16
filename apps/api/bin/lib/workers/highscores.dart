import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../utils/datetime.dart';
import '../utils/http.dart';
import '../utils/responses.dart';
import 'supabase_client.dart';

class Highscores {
  Future<Response> get(Request request) async {
    String? world = request.params['world'];
    String? category = request.params['category'];
    String? vocation = request.params['vocation'];
    int page = int.tryParse(request.params['page'] ?? '') ?? 1;
    CustomResponse? response;

    if (category != null && category.contains('experiencegained')) return _getExpGain(category, page);
    if (category != null && category.contains('onlinetime')) return _getOnlineTime(category, page);

    try {
      response = await Http().get('https://api.tibiadata.com/v3/highscores/$world/$category/$vocation/$page');
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess(data: response?.data);
  }

  Future<Response> _getExpGain(String category, int page) async {
    dynamic response;

    Map<String, String> table = <String, String>{
      'experiencegained+today': 'exp-gain-today',
      'experiencegained+yesterday': 'exp-gain-last-day',
      'experiencegained+last7days': 'exp-gain-last-7-days',
      'experiencegained+last30days': 'exp-gain-last-30-days',
    };

    Map<String, String> date = <String, String>{
      'experiencegained+today': MyDateTime.today(),
      'experiencegained+yesterday': MyDateTime.yesterday(),
      'experiencegained+last7days': MyDateTime.yesterday(),
      'experiencegained+last30days': MyDateTime.yesterday(),
    };

    try {
      response = await MySupabaseClient().client.from(table[category]!).select().eq('date', date[category]).single();

      List data = (response['highscores']['highscore_list'] as List<dynamic>?) ?? <dynamic>[];

      if ((page - 1) * 50 > data.length) {
        response['highscores']['highscore_list'] = [];
      } else {
        int start = (page - 1) * 50;
        int end = page * 50;
        if (start < 0) start = 0;
        if (end > data.length + 1) end = data.length;
        response['highscores']['highscore_list'] = data.getRange(start, end).toList();
      }
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess(data: response);
  }

  Future<Response> _getOnlineTime(String category, int page) async {
    dynamic response;
    dynamic data;

    Map<String, String> date = <String, String>{
      'onlinetime+today': MyDateTime.today(),
      'onlinetime+yesterday': MyDateTime.yesterday(),
    };

    try {
      response = await MySupabaseClient().client.from('online-time').select().eq('day', date[category]).single();
      List list = (response['players']['online_players'] as List<dynamic>?) ?? <dynamic>[];
      data = <String, dynamic>{};
      data['highscores'] = <String, dynamic>{};

      if ((page - 1) * 50 > list.length) {
        data['highscores']['highscore_list'] = [];
      } else {
        int start = (page - 1) * 50;
        int end = page * 50;
        if (start < 0) start = 0;
        if (end > list.length + 1) end = list.length;
        data['highscores']['highscore_list'] = list.getRange(start, end).toList();
      }
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess(data: data);
  }
}
