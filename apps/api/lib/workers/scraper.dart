import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:forgottenlandapi/utils/paths.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

abstract class IScraper {
  Future<Response> getExpRecord(Request request);
  Future<Response> getCurrentExp(Request request);
  Future<Response> getExpToday(Request request);
  Future<Response> getExpLastDay(Request request);
  Future<Response> getExpLast7Days(Request request);
  Future<Response> getExpLast30Days(Request request);
}

class Scraper implements IScraper {
  factory Scraper() => _singleton;
  Scraper._internal();
  static final Scraper _singleton = Scraper._internal();

  @override
  Future<Response> getExpRecord(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);
    return _getCurrentExp('exp-record', 'insert');
  }

  @override
  Future<Response> getCurrentExp(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);
    return _getCurrentExp('current-exp', 'update');
  }

  Future<Response> _getCurrentExp(String table, String operation) async {
    try {
      Record record = await _loadCurrentExp();
      await _saveCurrentExp(record, table, operation);
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess();
  }

  Future<Record> _loadCurrentExp() async {
    List<World> worlds = await _getWorlds();
    Record currentExp = Record(list: <HighscoresEntry>[]);

    for (World world in worlds) {
      int page = 1;
      Record? aux;

      do {
        aux = null;
        MyHttpResponse? response = await MyHttpClient().get(
          '${PATH.tibiaDataApi}/highscores/$world/experience/none/$page',
        );

        if (response.success) {
          aux = Record.fromJson((response.dataAsMap['highscores'] as Map<String, dynamic>?) ?? <String, dynamic>{});
          currentExp.list.addAll(aux.list);
          page++;
        }
      } while ((aux?.list.last.level ?? 0) > 30);
    }

    currentExp.list.removeWhere((e) => (e.level ?? 0) < 30);
    return currentExp;
  }

  Future<List<World>> _getWorlds() async {
    final MyHttpResponse response = await MyHttpClient().get('${PATH.tibiaDataApi}/worlds');
    final Map<String, dynamic>? data = response.data as Map<String, dynamic>?;
    List<World> worlds = [];

    if (data?['worlds']['regular_worlds'] is List<dynamic>) {
      for (dynamic e in data?['worlds']['regular_worlds'] as List<dynamic>) {
        if (e is Map<String, dynamic>) {
          worlds.add(World.fromJson(e));
        }
      }
    }

    return worlds;
  }

  Future<dynamic> _saveCurrentExp(Record record, String table, String operation) async {
    try {
      if (operation == 'update') {
        return DatabaseClient().from(table).update(
          <String, dynamic>{
            'data': record.toJson(),
            'timestamp': MyDateTime.timeStamp(),
          },
        ).match(
          <String, dynamic>{'world': 'All'},
        );
      }

      return DatabaseClient().from(table).insert(
        <String, dynamic>{
          'date': MyDateTime.today(),
          'world': 'All',
          'data': record.toJson(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getExpToday(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _calcExpGainToday();
      await _saveExpGain('exp-gain-today', MyDateTime.today(), result);
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess();
  }

  Future<Record> _calcExpGainToday() async {
    Record start = await _getWhere('exp-record', MyDateTime.today());
    dynamic response = await DatabaseClient().from('current-exp').select().single();
    Record end = Record.fromJson(response['data']);
    Record result = Record(list: <HighscoresEntry>[]);
    result.list.clear();
    result.list.addAll(_getExpDiff(start, end));
    _sortList(result.list);
    return result;
  }

  @override
  Future<Response> getExpLastDay(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _getExpGainRange(MyDateTime.yesterday(), MyDateTime.today());
      await _saveExpGain('exp-gain-last-day', MyDateTime.yesterday(), result);
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess();
  }

  @override
  Future<Response> getExpLast7Days(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _getExpGainRange(MyDateTime.aWeekAgo(), MyDateTime.today());
      await _saveExpGain('exp-gain-last-7-days', MyDateTime.yesterday(), result);
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess();
  }

  @override
  Future<Response> getExpLast30Days(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _getExpGainRange(MyDateTime.aMonthAgo(), MyDateTime.today());
      await _saveExpGain('exp-gain-last-30-days', MyDateTime.yesterday(), result);
    } catch (e) {
      return ApiResponseError(e);
    }
    return ApiResponseSuccess();
  }

  Future<Record> _getExpGainRange(String startDate, String endDate) async {
    Record start = await _getWhere('exp-record', startDate);
    Record end = await _getWhere('exp-record', endDate);
    Record result = Record(list: <HighscoresEntry>[]);
    result.list.addAll(_getExpDiff(start, end));
    _sortList(result.list);
    return result;
  }

  Future<Record> _getWhere(String table, String date) async {
    dynamic response = await DatabaseClient().from(table).select().eq('date', date).single();
    return Record.fromJson(response['data']);
  }

  List<HighscoresEntry> _getExpDiff(Record yesterday, Record today) {
    List<HighscoresEntry> newList = <HighscoresEntry>[];

    for (final HighscoresEntry t in today.list) {
      if (_isValidEntry(t, yesterday)) {
        HighscoresEntry y;
        y = yesterday.list.firstWhere((HighscoresEntry v) => v.name == t.name);

        t.value = t.value! - y.value!;

        if (t.value! > 0) newList.add(t);
      }
    }

    return newList;
  }

  bool _isValidEntry(HighscoresEntry t, Record record) {
    if (t.value is! int) return false;
    if (!record.list.any((HighscoresEntry y) => y.name == t.name)) return false;
    return record.list.firstWhere((HighscoresEntry y) => y.name == t.name).value is int;
  }

  void _sortList(List<HighscoresEntry> list) => list.sort(
        (HighscoresEntry a, HighscoresEntry b) => b.value!.compareTo(a.value!),
      );

  Future<dynamic> _saveExpGain(String table, String date, Record data) => DatabaseClient().from(table).insert(
        <String, dynamic>{
          'date': date,
          'world': 'All',
          'data': data.toJson(),
        },
      );
}
