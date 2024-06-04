import 'package:intl/intl.dart';
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
    this.expanded,
    this.isOnline = false,
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
      final int days = (json['time'] as int) ~/ (60 * 24);
      final int hours = ((json['time'] as int) % (60 * 24)) ~/ 60;
      final int minutes = (json['time'] as int) % 60;
      onlineTime = '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}m';
      if (days > 0) onlineTime = '${days.toString()}d$onlineTime';
    }
    if (json['expanded'] is Map) expanded = ExpandedData.fromJson(json['expanded'] as Map<String, dynamic>);
    if (json['is_online'] is bool) isOnline = json['is_online'] as bool;
  }

  HighscoresEntry.fromOnlineEntry(OnlineEntry online) {
    rank = online.rank;
    name = online.name;
    level = online.level;
    vocation = online.vocation;
    world = World(name: online.world);
    value = online.time;
    isOnline = online.isOnline;

    final int days = (value ?? 0) ~/ (60 * 24);
    final int hours = ((value ?? 0) % (60 * 24)) ~/ 60;
    final int minutes = (value ?? 0) % 60;
    onlineTime = '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}m';
    if (days > 0) onlineTime = '${days.toString()}d$onlineTime';
  }

  int? rank;
  String? name;
  String? vocation;
  World? world;
  int? level;
  int? value;
  String? supporterTitle;
  String? onlineTime;
  ExpandedData? expanded;
  bool isOnline = false;

  String? get stringValue => value == null ? null : NumberFormat.decimalPattern().format(value);

  String? get shortValue => value == null
      ? null
      : value! > 1000
          ? '${value! ~/ 1000}k'
          : value.toString();

  String? get shortTime => onlineTime == null
      ? null
      : (int.tryParse(onlineTime?.substring(0, 2) ?? '') ?? 0) > 0
          ? onlineTime?.substring(0, 3)
          : onlineTime?.substring(3, 6);

  bool match(String text) => name?.toLowerCase() == text;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['name'] = name;
    data['world'] = world?.toJson();
    data['level'] = level;
    data['value'] = value;
    data['expanded'] = expanded?.toJson();
    data['is_online'] = isOnline;
    return data.clean();
  }
}

class ExpandedData {
  ExpandedData();

  ExpandedData.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['experience'] is Map) experience = ExpandedEntry.fromJson(json['experience'] as Map<String, dynamic>);
    if (json['magic'] is Map) magic = ExpandedEntry.fromJson(json['magic'] as Map<String, dynamic>);
    if (json['fist'] is Map) fist = ExpandedEntry.fromJson(json['fist'] as Map<String, dynamic>);
    if (json['axe'] is Map) axe = ExpandedEntry.fromJson(json['axe'] as Map<String, dynamic>);
    if (json['club'] is Map) club = ExpandedEntry.fromJson(json['club'] as Map<String, dynamic>);
    if (json['sword'] is Map) sword = ExpandedEntry.fromJson(json['sword'] as Map<String, dynamic>);
    if (json['distance'] is Map) distance = ExpandedEntry.fromJson(json['distance'] as Map<String, dynamic>);
    if (json['shielding'] is Map) shielding = ExpandedEntry.fromJson(json['shielding'] as Map<String, dynamic>);
    if (json['fishing'] is Map) fishing = ExpandedEntry.fromJson(json['fishing'] as Map<String, dynamic>);
  }

  ExpandedEntry experience = ExpandedEntry();
  ExpandedEntry magic = ExpandedEntry();
  ExpandedEntry fist = ExpandedEntry();
  ExpandedEntry axe = ExpandedEntry();
  ExpandedEntry club = ExpandedEntry();
  ExpandedEntry sword = ExpandedEntry();
  ExpandedEntry distance = ExpandedEntry();
  ExpandedEntry shielding = ExpandedEntry();
  ExpandedEntry fishing = ExpandedEntry();

  void updateFromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['experience'] is Map) experience = ExpandedEntry.fromJson(json['experience'] as Map<String, dynamic>);
    if (json['magic'] is Map) magic = ExpandedEntry.fromJson(json['magic'] as Map<String, dynamic>);
    if (json['fist'] is Map) fist = ExpandedEntry.fromJson(json['fist'] as Map<String, dynamic>);
    if (json['axe'] is Map) axe = ExpandedEntry.fromJson(json['axe'] as Map<String, dynamic>);
    if (json['club'] is Map) club = ExpandedEntry.fromJson(json['club'] as Map<String, dynamic>);
    if (json['sword'] is Map) sword = ExpandedEntry.fromJson(json['sword'] as Map<String, dynamic>);
    if (json['distance'] is Map) distance = ExpandedEntry.fromJson(json['distance'] as Map<String, dynamic>);
    if (json['shielding'] is Map) shielding = ExpandedEntry.fromJson(json['shielding'] as Map<String, dynamic>);
    if (json['fishing'] is Map) fishing = ExpandedEntry.fromJson(json['fishing'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['experience'] = experience.toJson();
    data['magic'] = magic.toJson();
    data['fist'] = fist.toJson();
    data['axe'] = axe.toJson();
    data['club'] = club.toJson();
    data['sword'] = sword.toJson();
    data['distance'] = distance.toJson();
    data['shielding'] = shielding.toJson();
    data['fishing'] = fishing.toJson();
    return data.clean();
  }
}

class ExpandedEntry {
  ExpandedEntry({this.value, this.position, this.points});

  ExpandedEntry.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['value'] is int) value = json['value'] as int;
    if (json['position'] is int) position = json['position'] as int;
    if (json['points'] is int) points = json['points'] as int;
  }

  int? value;
  int? position;
  int? points;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['position'] = position;
    data['points'] = points;
    return data.clean();
  }
}
