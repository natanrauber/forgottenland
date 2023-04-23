import 'package:models/models.dart';
import 'package:utils/utils.dart';

class HighscoresEntry {
  HighscoresEntry({
    this.rank,
    this.name,
    this.vocation,
    this.world,
    this.level,
    this.value,
    this.supporterTitle,
    this.onlineTime,
  });

  HighscoresEntry.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['rank'] is int) rank = json['rank'] as int;
    if (json['name'] is String) name = json['name'] as String;
    if (json['level'] is int) level = json['level'] as int;
    if (json['value'] is int) value = json['value'] as int;
    if (json['world'] is String) world = World(name: json['world'] as String);
    if (json['world'] is Map<String, dynamic> && json['world']['name'] is String) {
      world = World(name: json['world']['name'] as String);
    }
    if (json['time'] is int) {
      final int hours = (json['time'] as int) ~/ 60;
      final int minutes = (json['time'] as int) % 60;
      onlineTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }
  }

  HighscoresEntry.fromOnlineEntry(OnlineEntry online) {
    name = online.name;
    level = online.level;
    vocation = online.vocation;
    value = online.time;

    final int hours = (value ?? 0) ~/ 60;
    final int minutes = (value ?? 0) % 60;
    onlineTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  int? rank;
  String? name;
  String? vocation;
  World? world;
  int? level;
  int? value;
  String? supporterTitle;
  String? onlineTime;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['world'] = world?.toJson();
    data['level'] = level;
    data['value'] = value;
    return data.clean();
  }
}
