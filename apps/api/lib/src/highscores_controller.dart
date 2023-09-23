import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/error_handler.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

class HighscoresController {
  HighscoresController(this.env, this.databaseClient, this.httpClient);

  final Env env;
  final IDatabaseClient databaseClient;
  final IHttpClient httpClient;

  Future<Response> get(Request request) async {
    String? world = request.params['world']?.toLowerCase();
    String? category = request.params['category']?.toLowerCase();
    String? vocation = request.params['vocation']?.toLowerCase();
    int page = int.tryParse(request.params['page'] ?? '') ?? 1;

    if (world == null) return ApiResponse.error('Missing param "world"');
    if (category == null) return ApiResponse.error('Missing param "category"');
    if (category.contains('experiencegained')) return getExpGain(world, category, page);
    if (category.contains('onlinetime')) return getOnlineTime(world, category, page);
    if (category.contains('rookmaster')) return getRookmaster(world, page);

    try {
      var response = await httpClient.get('${env['PATH_TIBIA_DATA']}/highscores/$world/$category/$vocation/$page');
      var record = Record.fromJson(response.dataAsMap['highscores'] as Map<String, dynamic>);
      return ApiResponse.success(data: record.toJson());
    } catch (e) {
      return handleError(e);
    }
  }

  String? _getTableFromCategory(String category) {
    Map<String, String> tables = <String, String>{
      'experiencegained+today': 'exp-gain-today',
      'experiencegained+yesterday': 'exp-gain-last-day',
      'experiencegained+last7days': 'exp-gain-last-7-days',
      'experiencegained+last30days': 'exp-gain-last-30-days',
      'onlinetime+today': 'onlinetime',
      'onlinetime+yesterday': 'onlinetime',
      'onlinetime+last7days': 'onlinetime-last7days',
      'onlinetime+last30days': 'onlinetime-last30days',
    };
    return tables[category];
  }

  String? _getDateFromCategory(String category) {
    Map<String, String> dates = <String, String>{
      'experiencegained+today': MyDateTime.today(),
      'experiencegained+yesterday': MyDateTime.yesterday(),
      'experiencegained+last7days': MyDateTime.yesterday(),
      'experiencegained+last30days': MyDateTime.yesterday(),
      'onlinetime+today': MyDateTime.today(),
      'onlinetime+yesterday': MyDateTime.yesterday(),
      'onlinetime+last7days': MyDateTime.yesterday(),
      'onlinetime+last30days': MyDateTime.yesterday(),
    };
    return dates[category];
  }

  List<T> _getPageRange<T>(int page, List<T> list) {
    if ((page - 1) * 50 > list.length) return [];
    if (list.length <= 50) return list;

    int start = (page - 1) * 50;
    int end = page * 50;
    if (end > list.length) end = list.length;
    return list.getRange(start, end).toList();
  }

  List<T> _filterWorld<T>(String world, List<T> list) {
    if (world == 'all') return list;
    if (list is List<OnlineEntry>) {
      list.removeWhere((e) => (e as OnlineEntry).world?.toLowerCase() != world);
    } else if (list is List<HighscoresEntry>) {
      list.removeWhere((e) => (e as HighscoresEntry).world?.name?.toLowerCase() != world);
    }
    return list;
  }

  List<T> _addMissingRank<T>(int? page, List<T> list) {
    if (list.isEmpty) return list;
    int offset = page == null ? 0 : 50 * (page - 1);
    if (list is List<HighscoresEntry>) {
      for (var e in list) {
        (e as HighscoresEntry).rank = list.indexOf(e) + 1 + offset;
      }
    } else if (list is List<OnlineEntry>) {
      for (var e in list) {
        (e as OnlineEntry).rank = list.indexOf(e) + 1 + offset;
      }
    }
    return list;
  }

  Future<Response> getExpGain(String world, String category, int? page) async {
    String? table = _getTableFromCategory(category);
    String? date = _getDateFromCategory(category);

    if (page != null && page <= 0) return ApiResponse.error('Invalid page number');
    if (table == null || date == null) return ApiResponse.error('Invalid category');

    try {
      var response = await databaseClient.from(table).select().eq('date', date).single();
      var record = Record.fromJson(response['data'] as Map<String, dynamic>);

      record.list = _filterWorld<HighscoresEntry>(world, record.list);
      if (page != null) record.list = _getPageRange<HighscoresEntry>(page, record.list);
      record.list = _addMissingRank<HighscoresEntry>(page, record.list);

      if (record.list.isEmpty) return ApiResponse.noContent();
      return ApiResponse.success(data: record.toJson());
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> getOnlineTime(String world, String category, int? page) async {
    String? table = _getTableFromCategory(category);
    String? date = _getDateFromCategory(category);

    if (page != null && page <= 0) return ApiResponse.error('Invalid page number');
    if (table == null || date == null) return ApiResponse.error('Invalid category');

    try {
      var response = await databaseClient.from(table).select().eq('date', date).single();
      var online = Online.fromJson(response['data'] as Map<String, dynamic>);

      online.list = _filterWorld<OnlineEntry>(world, online.list);
      if (page != null) online.list = _getPageRange<OnlineEntry>(page, online.list);
      online.list = _addMissingRank<OnlineEntry>(page, online.list);

      if (online.list.isEmpty) return ApiResponse.noContent();
      return ApiResponse.success(data: online.toJson());
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> getRookmaster(String world, int? page) async {
    if (page != null && page < 0) return ApiResponse.error('Invalid page number');

    try {
      var response = await databaseClient.from('rook-master').select().order('date').limit(1).single();
      var record = Record.fromJson(response['data'] as Map<String, dynamic>);

      record.list = _filterWorld<HighscoresEntry>(world, record.list);
      if (page != null) record.list = _getPageRange<HighscoresEntry>(page, record.list);
      record.list = _addMissingRank<HighscoresEntry>(page, record.list);

      if (record.list.isEmpty) return ApiResponse.noContent();
      return ApiResponse.success(data: record.toJson());
    } catch (e) {
      return handleError(e);
    }
  }
}
