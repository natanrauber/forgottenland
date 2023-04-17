import 'package:models/models.dart';
import 'package:shelf/shelf.dart';

import '../utils/datetime.dart';
import '../utils/http.dart';
import '../utils/responses.dart';
import 'supabase_client.dart';

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
    MySupabaseClient().start(supabaseUrl, supabaseKey);
    return _getCurrentExp('exp-record', 'insert');
  }

  @override
  Future<Response> getCurrentExp(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    MySupabaseClient().start(supabaseUrl, supabaseKey);
    return _getCurrentExp('current-exp', 'update');
  }

  Future<Response> _getCurrentExp(String table, String operation) async {
    try {
      Record record = await _loadCurrentExp();
      await _saveCurrentExp(record, table, operation);
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess();
  }

  Future<Record> _loadCurrentExp() async {
    List<World> worlds = await _getWorlds();
    Record currentExp = Record(list: <HighscoresEntry>[]);

    for (World world in worlds) {
      int page = 1;
      Record? aux;

      do {
        aux = null;
        CustomResponse? response = await Http().get('/highscores/$world/experience/none/$page');

        if (response.success) {
          aux = Record.fromJson((response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{});
          currentExp.list.addAll(aux.list);
          page++;
        }
      } while ((aux?.list.last.level ?? 0) > 30);
    }

    return currentExp;
  }

  Future<List<World>> _getWorlds() async {
    final CustomResponse response = await Http().get('/worlds');
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
        return MySupabaseClient().client.from(table).update(
          <String, dynamic>{
            'data': record.toJson(),
            'timestamp': MyDateTime.timeStamp(),
          },
        ).match(
          <String, dynamic>{'world': 'All'},
        );
      }

      return MySupabaseClient().client.from(table).insert(
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
    MySupabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _calcExpGainToday();
      await _saveExpGainToday(result);
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess();
  }

  Future<Record> _calcExpGainToday() async {
    dynamic response = await _getWhere('exp-record', MyDateTime.today());
    Record start = Record.fromJson(response['data']);

    response = await MySupabaseClient().client.from('current-exp').select().single();
    Record end = Record.fromJson(response['data']);

    Record result = Record(list: <HighscoresEntry>[]);

    result.list.clear();
    result.list.addAll(_getExpDiff(start, end));
    _sortList(result.list);

    return result;
  }

  Future<dynamic> _saveExpGainToday(Record data) => MySupabaseClient().client.from('exp-gain-today').upsert(
        <String, dynamic>{
          'date': MyDateTime.today(),
          'world': 'All',
          'data': data.toJson(),
          'timestamp': MyDateTime.timeStamp(),
        },
      );

  @override
  Future<Response> getExpLastDay(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    MySupabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _calcExpGainLastDay();
      await _saveExpGainLastDay(result);
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess();
  }

  Future<Record> _calcExpGainLastDay() async {
    Map<String, dynamic> json = await _getWhere('exp-record', MyDateTime.yesterday());
    Record yesterday = Record.fromJson(json);

    json = await _getWhere('exp-record', MyDateTime.today());
    Record today = Record.fromJson(json);

    Record result = Record(list: <HighscoresEntry>[]);

    result.list.clear();
    result.list.addAll(_getExpDiff(yesterday, today));
    _sortList(result.list);

    return result;
  }

  Future<dynamic> _getWhere(String table, String date) async {
    return await MySupabaseClient().client.from(table).select().eq('date', date).single();
  }

  List<HighscoresEntry> _getExpDiff(Record yesterday, Record today) {
    List<HighscoresEntry> newList;
    newList = <HighscoresEntry>[];

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

  Future<dynamic> _saveExpGainLastDay(Record data) => MySupabaseClient().client.from('exp-gain-last-day').insert(
        <String, dynamic>{
          'date': MyDateTime.yesterday(),
          'world': 'All',
          'data': data.toJson(),
        },
      );

  @override
  Future<Response> getExpLast7Days(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    MySupabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _calcExpGainLast7Days();
      await _saveExpGainLast7Days(result);
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess();
  }

  Future<Record> _calcExpGainLast7Days() async {
    dynamic response = await _getWhere('exp-record', MyDateTime.aWeekAgo());
    Record start = Record.fromJson(response['data']);

    response = await _getWhere('exp-record', MyDateTime.today());
    Record end = Record.fromJson(response['data']);

    Record result = Record(list: <HighscoresEntry>[]);

    result.list.clear();
    result.list.addAll(_getExpDiff(start, end));
    _sortList(result.list);

    return result;
  }

  Future<dynamic> _saveExpGainLast7Days(Record data) => MySupabaseClient().client.from('exp-gain-last-7-days').insert(
        <String, dynamic>{
          'date': MyDateTime.yesterday(),
          'world': 'All',
          'data': data.toJson(),
        },
      );

  @override
  Future<Response> getExpLast30Days(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    MySupabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _calcExpGainLast30Days();
      await _saveExpGainLast30Days(result);
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess();
  }

  Future<Record> _calcExpGainLast30Days() async {
    Map<String, dynamic> json = await _getWhere('exp-record', MyDateTime.aMonthAgo());
    Record start = Record.fromJson(json);

    json = await _getWhere('exp-record', MyDateTime.today());
    Record end = Record.fromJson(json);

    Record result = Record(list: <HighscoresEntry>[]);

    result.list.clear();
    result.list.addAll(_getExpDiff(start, end));
    _sortList(result.list);

    return result;
  }

  Future<dynamic> _saveExpGainLast30Days(Record data) => MySupabaseClient().client.from('exp-gain-last-30-days').insert(
        <String, dynamic>{
          'date': MyDateTime.yesterday(),
          'world': 'All',
          'data': data.toJson(),
        },
      );
}
