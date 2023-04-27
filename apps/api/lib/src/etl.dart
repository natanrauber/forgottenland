import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:forgottenlandapi/utils/paths.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

abstract class IETL {
  Future<Response> expRecord(Request request);
  Future<Response> currentExp(Request request);
  Future<Response> expGainedToday(Request request);
  Future<Response> expGainedYesterday(Request request);
  Future<Response> expGainedLast7Days(Request request);
  Future<Response> expGainedLast30Days(Request request);
  Future<Response> registerOnlinePlayers(Request request);
}

// Extract, Transform, Load.
class ETL implements IETL {
  factory ETL() => _singleton;
  ETL._internal();
  static final ETL _singleton = ETL._internal();

  @override
  Future<Response> expRecord(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);
    if (await _exists('exp-record', MyDateTime.today())) return ApiResponseAccepted();
    return _getCurrentExp('exp-record', 'insert');
  }

  @override
  Future<Response> currentExp(Request request) async {
    String? supabaseUrl = request.headers['supabaseUrl'];
    String? supabaseKey = request.headers['supabaseKey'];
    DatabaseClient().start(supabaseUrl, supabaseKey);
    return _getCurrentExp('current-exp', 'update');
  }

  Future<Response> _getCurrentExp(String table, String operation) async {
    try {
      Record record = await _loadCurrentExp();
      await _saveCurrentExp(record, table, operation);
      return ApiResponseSuccess();
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  Future<Record> _loadCurrentExp() async {
    List<World> worlds = await _getWorlds();
    Record currentExp = Record(list: <HighscoresEntry>[]);

    for (World world in worlds) {
      Record? aux;
      int page = 1;
      int i = 0;
      bool retry = false;
      bool loadNext = false;

      do {
        if (retry) page--;
        i = retry ? i++ : 0;

        retry = false;
        loadNext = false;

        aux = null;
        var response = await MyHttpClient().get('${PATH.tibiaDataApi}/highscores/$world/experience/none/$page');

        if (response.success) {
          aux = Record.fromJson(response.dataAsMap['highscores'] as Map<String, dynamic>);
          aux.list.removeWhere((e) => (e.level ?? 0) < 30);
          currentExp.list.addAll(aux.list);
          page++;
        }

        if (!response.success && i < 5) retry = true;
        if (aux?.list.isNotEmpty == true && (aux?.list.last.level ?? 0) > 30) loadNext = true;
      } while (retry || loadNext);
    }

    currentExp.list.sort((a, b) => (b.value ?? 0).compareTo(a.value ?? 0));
    return currentExp;
  }

  Future<List<World>> _getWorlds() async {
    final MyHttpResponse response = await MyHttpClient().get('${PATH.tibiaDataApi}/worlds');

    if (response.dataAsMap['worlds'] is! Map) return [];
    if (response.dataAsMap['worlds']['regular_worlds'] is! List) return [];

    List data = response.dataAsMap['worlds']['regular_worlds'];
    List<World> worlds = [];

    for (dynamic e in data) {
      if (e is Map<String, dynamic>) worlds.add(World.fromJson(e));
    }
    return worlds;
  }

  Future<dynamic> _saveCurrentExp(Record record, String table, String operation) async {
    if (operation == 'update') {
      var values = <String, dynamic>{'data': record.toJson(), 'timestamp': MyDateTime.timeStamp()};
      return DatabaseClient().from(table).update(values).match(<String, dynamic>{'world': 'All'});
    }
    var values = <String, dynamic>{'date': MyDateTime.today(), 'world': 'All', 'data': record.toJson()};
    return DatabaseClient().from(table).insert(values);
  }

  @override
  Future<Response> expGainedToday(Request request) async {
    String? supabaseUrl = request.headers['supabaseUrl'];
    String? supabaseKey = request.headers['supabaseKey'];
    DatabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Record result = await _calcExpGainToday();
      await _saveExpGain('exp-gain-today', MyDateTime.today(), result, canUpdate: true);
      return ApiResponseSuccess();
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  Future<Record> _calcExpGainToday() async {
    Record start = await _getWhere('exp-record', MyDateTime.today());
    dynamic response = await DatabaseClient().from('current-exp').select().single();
    Record end = Record.fromJson(response['data']);
    Record result = Record(list: <HighscoresEntry>[]);
    result.list.addAll(_getExpDiff(start, end));
    result.list.sort((HighscoresEntry a, HighscoresEntry b) => (b.value ?? 0).compareTo(a.value ?? 0));
    return result;
  }

  @override
  Future<Response> expGainedYesterday(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);

    if (await _exists('exp-gain-last-day', MyDateTime.yesterday())) return ApiResponseAccepted();

    try {
      Record result = await _getExpGainRange(MyDateTime.yesterday(), MyDateTime.today());
      await _saveExpGain('exp-gain-last-day', MyDateTime.yesterday(), result);
      return ApiResponseSuccess();
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  @override
  Future<Response> expGainedLast7Days(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);

    if (await _exists('exp-gain-last-7-days', MyDateTime.yesterday())) return ApiResponseAccepted();

    try {
      Record result = await _getExpGainRange(MyDateTime.aWeekAgo(), MyDateTime.today());
      await _saveExpGain('exp-gain-last-7-days', MyDateTime.yesterday(), result);
      return ApiResponseSuccess();
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  @override
  Future<Response> expGainedLast30Days(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    DatabaseClient().start(supabaseUrl, supabaseKey);

    if (await _exists('exp-gain-last-30-days', MyDateTime.yesterday())) return ApiResponseAccepted();

    try {
      Record result = await _getExpGainRange(MyDateTime.aMonthAgo(), MyDateTime.today());
      await _saveExpGain('exp-gain-last-30-days', MyDateTime.yesterday(), result);
      return ApiResponseSuccess();
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  Future<Record> _getExpGainRange(String startDate, String endDate) async {
    Record start = await _getWhere('exp-record', startDate);
    Record end = await _getWhere('exp-record', endDate);
    Record result = Record(list: <HighscoresEntry>[]);
    result.list.addAll(_getExpDiff(start, end));
    result.list.sort((HighscoresEntry a, HighscoresEntry b) => (b.value ?? 0).compareTo(a.value ?? 0));
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
        var y = yesterday.list.firstWhere((HighscoresEntry v) => v.name == t.name);
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

  Future<dynamic> _saveExpGain(String table, String date, Record data, {bool canUpdate = false}) {
    if (canUpdate) {
      var values = <String, dynamic>{'date': date, 'world': 'All', 'data': data.toJson()};
      return DatabaseClient().from(table).upsert(values);
    }
    var values = <String, dynamic>{'date': date, 'world': 'All', 'data': data.toJson()};
    return DatabaseClient().from(table).insert(values);
  }

  Future<bool> _exists(String table, String date) async {
    List<dynamic> response = await DatabaseClient().from(table).select().eq('date', date);
    return response.isNotEmpty;
  }

  @override
  Future<Response> registerOnlinePlayers(Request request) async {
    try {
      DatabaseClient().start(request.headers['supabaseUrl'], request.headers['supabaseKey']);

      Online onlineNow = await _getOnlineNow();
      await _saveOnlineNow(onlineNow);

      await _saveOnlineTimeToday(await _getOnlineTimeToday(onlineNow));

      await _saveOnlineTimeLast7days(await _getOnlineTimeLast7days());

      return ApiResponseSuccess();
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  Future<Online> _getOnlineNow() async {
    List<World> worlds = await _getWorlds();
    Online online = Online(list: <OnlineEntry>[]);

    for (World world in worlds) {
      MyHttpResponse response;
      int i = 1;

      do {
        response = await MyHttpClient().get('${PATH.tibiaDataApi}/world/$world');
        if (response.success) {
          Online aux = Online.fromJsonTibiaDataAPI(response.dataAsMap);
          aux.list.removeWhere((e) => e.vocation != 'None' || (e.level ?? 0) < 5);
          for (var e in aux.list) {
            e.world = world.name;
          }
          online.list.addAll(aux.list);
        }
      } while (!response.success && i != 5);
    }

    online.list.sort((a, b) => (b.level ?? 0).compareTo(a.level ?? 0));
    return online;
  }

  Future<dynamic> _saveOnlineNow(Online online) async {
    var values = <String, dynamic>{'data': online.toJson(), 'timestamp': MyDateTime.timeStamp()};
    return DatabaseClient().from('online').update(values).match(<String, dynamic>{'world': 'All'});
  }

  Future<Online> _getOnlineTimeToday(Online onlineNow) async {
    onlineNow.list.removeWhere((e) => (e.level ?? 0) < 10);
    List<dynamic> response = await DatabaseClient().from('onlinetime').select().eq('date', MyDateTime.today());
    Online onlineTime;

    if (response.isEmpty) {
      onlineTime = Online(list: onlineNow.list);
    } else {
      onlineTime = Online.fromJson(response.first['data']);
      for (var now in onlineNow.list) {
        if (onlineTime.list.any((e) => e.name == now.name)) {
          onlineTime.list.firstWhere((e) => e.name == now.name).time += 5;
          onlineTime.list.firstWhere((e) => e.name == now.name).level = now.level;
        } else {
          onlineTime.list.add(now);
        }
      }
    }

    onlineTime.list.sort(_compareTo);
    return onlineTime;
  }

  int _compareTo(OnlineEntry a, OnlineEntry b) {
    if (a.time != b.time) return b.time.compareTo(a.time);
    return (b.level ?? 0).compareTo((a.level ?? 0));
  }

  Future<dynamic> _saveOnlineTimeToday(Online online) async {
    var values = <String, dynamic>{'date': MyDateTime.today(), 'data': online.toJson()};
    return DatabaseClient().from('onlinetime').upsert(values).match(<String, dynamic>{'date': MyDateTime.now()});
  }

  Future<Online?> _getOnlineTimeLast7days() async {
    if (await _exists('onlinetime-last7days', MyDateTime.yesterday())) return null;

    DateTime start = MyDateTime.now().subtract(Duration(days: 7));
    DateTime end = MyDateTime.now().subtract(Duration(days: 1));
    Online result = Online(list: <OnlineEntry>[]);

    for (String date in MyDateTime.range(start, end)) {
      List<dynamic> response = await DatabaseClient().from('online-time').select().eq('day', date);

      if (response.isNotEmpty) {
        Online onlineTimeOnDate = Online.fromJson(response.first['data']);
        for (var dayE in onlineTimeOnDate.list) {
          if (result.list.any((resultE) => resultE.name == dayE.name)) {
            result.list.firstWhere((resultE) => resultE.name == dayE.name).time += dayE.time;
            result.list.firstWhere((resultE) => resultE.name == dayE.name).level = dayE.level;
            result.list.firstWhere((resultE) => resultE.name == dayE.name).world ??= dayE.world;
          } else {
            result.list.add(dayE);
          }
        }
      }
    }

    result.list.sort(_compareTo);

    return result;
  }

  Future<dynamic> _saveOnlineTimeLast7days(Online? onlineTime) async {
    if (onlineTime == null) return;
    var values = <String, dynamic>{'date': MyDateTime.yesterday(), 'data': onlineTime.toJson()};
    return DatabaseClient().from('onlinetime-last7days').insert(values);
  }
}
