import 'package:shelf/shelf.dart';

import '../models/record_model.dart';
import '../models/world_model.dart';
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
    Record currentExp = Record(highscoreList: <HighscoreEntry>[]);

    for (World world in worlds) {
      int page = 1;
      Record? aux;

      do {
        aux = null;
        CustomResponse? response = await Http().get('/highscores/$world/experience/none/$page');

        if (response?.statusCode == 200) {
          Map<String, dynamic> json =
              (response?.dataAsMap['highscores'] as Map<String, dynamic>?) ?? <String, dynamic>{};
          aux = Record.fromJson(json);
          currentExp.highscoreList.addAll(aux.highscoreList);
          page++;
        }
      } while ((aux?.highscoreList.last.level ?? 0) > 30);
    }

    return currentExp;
  }

  Future<List<World>> _getWorlds() async {
    final CustomResponse? response = await Http().get('/worlds');
    final Map<String, dynamic>? data = response?.data as Map<String, dynamic>?;
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
            'highscores': record.toJson(),
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
          'highscores': record.toJson(),
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
    Map<String, dynamic> json = await _getWhere('exp-record', MyDateTime.today());
    Record start = Record.fromJson(json);

    dynamic response;
    response = await MySupabaseClient().client.from('current-exp').select().single();
    json = (response['highscores'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    Record end = Record.fromJson(json);
    Record result = Record(highscoreList: <HighscoreEntry>[]);

    result.highscoreList.clear();
    result.highscoreList.addAll(_getExpDiff(start, end));
    _sortList(result.highscoreList);

    return result;
  }

  Future<dynamic> _saveExpGainToday(Record data) => MySupabaseClient().client.from('exp-gain-today').upsert(
        <String, dynamic>{
          'date': MyDateTime.today(),
          'world': 'All',
          'highscores': data.toJson(),
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

    Record result = Record(highscoreList: <HighscoreEntry>[]);

    result.highscoreList.clear();
    result.highscoreList.addAll(_getExpDiff(yesterday, today));
    _sortList(result.highscoreList);

    return result;
  }

  Future<Map<String, dynamic>> _getWhere(String table, String date) async {
    dynamic response;
    response = await MySupabaseClient().client.from(table).select().eq('date', date).single();
    return (response['highscores'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  }

  List<HighscoreEntry> _getExpDiff(Record yesterday, Record today) {
    List<HighscoreEntry> newList;
    newList = <HighscoreEntry>[];

    for (final HighscoreEntry t in today.highscoreList) {
      if (_isValidEntry(t, yesterday)) {
        HighscoreEntry y;
        y = yesterday.highscoreList.firstWhere((HighscoreEntry v) => v.name == t.name);

        t.value = t.value! - y.value!;

        if (t.value! > 0) newList.add(t);
      }
    }

    return newList;
  }

  bool _isValidEntry(HighscoreEntry t, Record record) {
    if (t.value is! int) return false;
    if (!record.highscoreList.any((HighscoreEntry y) => y.name == t.name)) return false;
    return record.highscoreList.firstWhere((HighscoreEntry y) => y.name == t.name).value is int;
  }

  void _sortList(List<HighscoreEntry> list) => list.sort(
        (HighscoreEntry a, HighscoreEntry b) => b.value!.compareTo(a.value!),
      );

  Future<dynamic> _saveExpGainLastDay(Record data) => MySupabaseClient().client.from('exp-gain-last-day').insert(
        <String, dynamic>{
          'date': MyDateTime.yesterday(),
          'world': 'All',
          'highscores': data.toJson(),
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
    Map<String, dynamic> json = await _getWhere('exp-record', MyDateTime.aWeekAgo());
    Record start = Record.fromJson(json);

    json = await _getWhere('exp-record', MyDateTime.today());
    Record end = Record.fromJson(json);

    Record result = Record(highscoreList: <HighscoreEntry>[]);

    result.highscoreList.clear();
    result.highscoreList.addAll(_getExpDiff(start, end));
    _sortList(result.highscoreList);

    return result;
  }

  Future<dynamic> _saveExpGainLast7Days(Record data) => MySupabaseClient().client.from('exp-gain-last-7-days').insert(
        <String, dynamic>{
          'date': MyDateTime.yesterday(),
          'world': 'All',
          'highscores': data.toJson(),
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

    Record result = Record(highscoreList: <HighscoreEntry>[]);

    result.highscoreList.clear();
    result.highscoreList.addAll(_getExpDiff(start, end));
    _sortList(result.highscoreList);

    return result;
  }

  Future<dynamic> _saveExpGainLast30Days(Record data) => MySupabaseClient().client.from('exp-gain-last-30-days').insert(
        <String, dynamic>{
          'date': MyDateTime.yesterday(),
          'world': 'All',
          'highscores': data.toJson(),
        },
      );
}
