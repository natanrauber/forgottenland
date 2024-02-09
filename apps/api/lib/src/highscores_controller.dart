import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/error_handler.dart';
import 'package:forgottenlandapi/utils/maps.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

class HighscoresController {
  HighscoresController(this.env, this.databaseClient, this.httpClient);

  final Env env;
  final IDatabaseClient databaseClient;
  final IHttpClient httpClient;

  Future<Response> get(Request request, String world, String category, String page) async {
    int pageAux = int.tryParse(page) ?? 1;

    if (category.contains('experiencegained')) return getExpGain(world, category, pageAux);
    if (category.contains('onlinetime')) return getOnlineTime(world, category, pageAux);
    if (category.contains('rookmaster')) return getRookmaster(world, pageAux);
    return getFromTibiaData(world, category, pageAux);
  }

  Future<Response> getFromTibiaData(String? world, String? category, int page) async {
    try {
      MyHttpResponse response = await httpClient.get(
        '${env['PATH_TIBIA_DATA']}/highscores/$world/$category/none/$page',
      );
      Record record = Record.fromJson(response.dataAsMap['highscores'] as Map<String, dynamic>);
      return ApiResponse.success(data: record.toJson());
    } catch (e) {
      return handleError(e);
    }
  }

  List<T> _filterWorld<T>(String world, List<T> list) {
    if (world == 'all') return list;
    if (list is List<OnlineEntry>) {
      list.removeWhere((T e) => (e as OnlineEntry).world?.toLowerCase() != world);
    } else if (list is List<HighscoresEntry>) {
      list.removeWhere((T e) => (e as HighscoresEntry).world?.name?.toLowerCase() != world);
    }
    return list;
  }

  List<T> _addMissingRank<T>(int? page, List<T> list) {
    if (list.isEmpty) return list;
    int offset = page == null ? 0 : 50 * (page - 1);
    if (list is List<HighscoresEntry>) {
      for (T e in list) {
        (e as HighscoresEntry).rank = list.indexOf(e) + 1 + offset;
      }
    } else if (list is List<OnlineEntry>) {
      for (T e in list) {
        (e as OnlineEntry).rank = list.indexOf(e) + 1 + offset;
      }
    }
    return list;
  }

  Future<Response> getExpGain(String world, String category, int? page) async {
    String? table = tableToCategory[category];
    String? date = dateToCategory[category];

    if (page != null && page <= 0) return ApiResponse.error('Invalid page number');
    if (table == null || date == null) return ApiResponse.error('Invalid category');

    try {
      dynamic response = await databaseClient.from(table).select().eq('date', date).maybeSingle();
      if (response is! Map<String, dynamic>) return ApiResponse.noContent();
      if (response['data'] is! Map<String, dynamic>) return ApiResponse.noContent();

      Record record = Record.fromJson(response['data'] as Map<String, dynamic>);
      record.timestamp = response['timestamp'] as String?;

      record.list = _filterWorld<HighscoresEntry>(world, record.list);
      if (page != null) record.list = record.list.getSegment<HighscoresEntry>(size: 50, index: page - 1);
      record.list = _addMissingRank<HighscoresEntry>(page, record.list);

      if (record.list.isEmpty) return ApiResponse.noContent();
      return ApiResponse.success(data: record.toJson());
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> getOnlineTime(String world, String category, int? page) async {
    String? table = tableToCategory[category];
    String? date = dateToCategory[category];

    if (page != null && page <= 0) return ApiResponse.error('Invalid page number');
    if (table == null || date == null) return ApiResponse.error('Invalid category');

    try {
      dynamic response = await databaseClient.from(table).select().eq('date', date).maybeSingle();
      if (response is! Map<String, dynamic>) return ApiResponse.noContent();
      if (response['data'] is! Map<String, dynamic>) return ApiResponse.noContent();

      Online online = Online.fromJson(response['data'] as Map<String, dynamic>);

      online.list = _filterWorld<OnlineEntry>(world, online.list);
      if (page != null) online.list = online.list.getSegment<OnlineEntry>(size: 50, index: page - 1);
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
      dynamic response = await databaseClient.from('rook-master').select().order('date').limit(1).maybeSingle();
      if (response == null) return ApiResponse.noContent();
      Record record = Record.fromJson(response['data'] as Map<String, dynamic>);
      record.timestamp = response['timestamp'] as String?;

      record.list = _filterWorld<HighscoresEntry>(world, record.list);
      if (page != null) record.list = record.list.getSegment<HighscoresEntry>(size: 50, index: page - 1);
      record.list = _addMissingRank<HighscoresEntry>(page, record.list);

      if (record.list.isEmpty) return ApiResponse.noContent();
      return ApiResponse.success(data: record.toJson());
    } catch (e) {
      return handleError(e);
    }
  }
}
