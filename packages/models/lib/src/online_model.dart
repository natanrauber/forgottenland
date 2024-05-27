import 'package:utils/utils.dart';

class Online {
  Online({this.list = const <OnlineEntry>[]});

  Online.fromJsonTibiaDataAPI(Map<String, dynamic> json) {
    if (json['world'] is! Map<String, dynamic>) return;
    if (json['world']['online_players'] is! List<dynamic>) return;

    for (final dynamic e in json['world']['online_players']) {
      if (e is Map<String, dynamic>) list.add(OnlineEntry.fromJson(e));
    }
  }

  Online.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['online_players'] is! List<dynamic>) return;

    for (final dynamic e in json['online_players']) {
      if (e is Map<String, dynamic>) list.add(OnlineEntry.fromJson(e));
    }
  }

  List<OnlineEntry> list = <OnlineEntry>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['online_players'] = list.map((OnlineEntry e) => e.toJson()).toList();
    return data.clean();
  }
}

class OnlineEntry {
  OnlineEntry({
    this.rank,
    this.name,
    this.level,
    this.vocation,
    this.world,
    this.time = 5,
    this.isOnline = false,
  });

  OnlineEntry.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['rank'] is int) rank = json['rank'] as int;
    if (json['name'] is String) name = json['name'] as String;
    if (json['level'] is int) level = json['level'] as int;
    if (json['vocation'] is String) vocation = json['vocation'] as String;
    if (json['world'] is String) world = json['world'] as String;
    if (json['time'] is int) time = json['time'] as int;
    if (json['is_online'] is bool) isOnline = json['is_online'] as bool;
  }

  int? rank;
  String? name;
  int? level;
  String? vocation;
  String? world;
  int time = 5;
  bool isOnline = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['name'] = name;
    data['level'] = level;
    data['world'] = world;
    data['time'] = time;
    data['is_online'] = isOnline;
    return data.clean();
  }
}
