import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/online_model.dart';
import '../models/world_model.dart';
import '../utils/datetime.dart';
import '../utils/http.dart';
import '../utils/responses.dart';
import 'supabase_client.dart';

abstract class IOnlineController {
  Future<Response> getOnlineNow(Request request);
  Future<Response> getOnlineTime(Request request);
  Future<Response> registerOnlinePlayers(Request request);
}

class OnlineController implements IOnlineController {
  factory OnlineController() => _singleton;
  OnlineController._internal();
  static final OnlineController _singleton = OnlineController._internal();

  @override
  Future<Response> getOnlineNow(Request request) async {
    dynamic response;

    try {
      response = await MySupabaseClient().client.from('online').select().single();
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess(data: response);
  }

  @override
  Future<Response> getOnlineTime(Request request) async {
    String? day = request.params['day'];
    dynamic response;

    try {
      response = await MySupabaseClient().client.from('online-time').select().eq('day', day).single();
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess(data: response);
  }

  @override
  Future<Response> registerOnlinePlayers(Request request) async {
    String supabaseUrl = request.headers['supabaseUrl'] ?? '';
    String supabaseKey = request.headers['supabaseKey'] ?? '';
    MySupabaseClient().start(supabaseUrl, supabaseKey);

    try {
      Online onlineNow = await _getOnlineNow();
      await _saveOnlineNow(onlineNow);
      Online onlineTime = await _getOnlineTime(onlineNow);
      await _saveOnlineTime(onlineTime);
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess();
  }

  Future<Online> _getOnlineNow() async {
    List<World> worlds = await _getWorlds();
    Online online = Online(list: <OnlineEntry>[]);

    for (World world in worlds) {
      int i = 1;
      CustomResponse? response;

      do {
        response = await Http().get('/world/$world');

        if (response?.statusCode == 200) {
          Online? aux = Online.fromJson(response?.dataAsMap ?? <String, dynamic>{});
          aux.list.removeWhere((e) => (e.level ?? 0) < 5);
          for (var e in aux.list) {
            e.world = world.name;
          }
          online.list.addAll(aux.list.where((e) => e.vocation == 'None'));
        }
      } while (response?.statusCode != 200 && i != 5);
    }

    online.list.sort((a, b) => (b.level ?? 0).compareTo(a.level ?? 0));

    return online;
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

  Future<dynamic> _saveOnlineNow(Online online) async {
    try {
      return MySupabaseClient().client.from('online').update(
        <String, dynamic>{
          'players': online.toJson(),
          'timestamp': MyDateTime.timeStamp(),
        },
      ).match(
        <String, dynamic>{'world': 'All'},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Online> _getOnlineTime(Online onlineNow) async {
    Online onlineTime = Online(list: <OnlineEntry>[]);

    try {
      List<dynamic> response = await MySupabaseClient().client.from('online-time').select().eq(
            'day',
            MyDateTime.today(),
          );
      if (response.isEmpty) {
        onlineTime.list.addAll(onlineNow.list.where((e) => (e.level ?? 0) >= 10).toList());
      } else {
        for (var e in response.first['players']['online_players']) {
          onlineTime.list.add(OnlineEntry.fromJson(e));
        }
        for (var now in onlineNow.list) {
          if (onlineTime.list.any((e) => e.name == now.name)) {
            onlineTime.list.firstWhere((e) => e.name == now.name).time += 5;
            onlineTime.list.firstWhere((e) => e.name == now.name).level = now.level;
          } else {
            if ((now.level ?? 0) >= 10) onlineTime.list.add(now);
          }
        }
      }
    } catch (e) {
      rethrow;
    }

    onlineTime.list.sort(_compareTo);
    return onlineTime;
  }

  int _compareTo(OnlineEntry a, OnlineEntry b) {
    if (a.time != b.time) return b.time.compareTo(a.time);
    return (b.level ?? 0).compareTo((a.level ?? 0));
  }

  Future<dynamic> _saveOnlineTime(Online online) async {
    try {
      return MySupabaseClient().client.from('online-time').upsert(
        <String, dynamic>{
          'day': MyDateTime.today(),
          'players': online.toJson(),
          'timestamp': MyDateTime.timeStamp(),
        },
      ).match(
        <String, dynamic>{'day': MyDateTime.now()},
      );
    } catch (e) {
      rethrow;
    }
  }
}
