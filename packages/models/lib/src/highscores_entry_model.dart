import 'package:models/src/world_model.dart';

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
    if (json['rank'] is int) rank = json['rank'] as int;
    if (json['name'] is String) name = json['name'] as String;
    if (json['level'] is int) level = json['level'] as int;
    if (json['value'] is int) value = json['value'] as int;
    if (json['world'] is String) world = World(name: json['world'] as String);
    if (json['time'] is int) {
      final int hours = (json['time'] as int) ~/ 60;
      final int minutes = (json['time'] as int) % 60;
      onlineTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }
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
    data['rank'] = rank;
    data['name'] = name;
    data['vocation'] = vocation;
    data['world'] = world;
    data['level'] = level;
    data['value'] = value;
    return data;
  }
}
