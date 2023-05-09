import 'package:models/src/highscores_entry_model.dart';
import 'package:utils/utils.dart';

class Record {
  Record({this.list = const <HighscoresEntry>[]});

  Record.fromJson(Map<String, dynamic> json) {
    json.clean();
    List<dynamic> responseList = <dynamic>[];

    if (json['highscore_list'] is List<dynamic>) responseList = json['highscore_list'] as List<dynamic>;
    if (json['online_players'] is List<dynamic>) responseList = json['online_players'] as List<dynamic>;

    for (final dynamic e in responseList) {
      if (e is Map<String, dynamic>) {
        HighscoresEntry entry = HighscoresEntry.fromJson(e);
        if ((entry.level ?? 0) >= 10) list.add(entry);
      }
    }
  }

  Record.fromJsonExpanded(Map<String, dynamic> json) {
    json.clean();
    List<dynamic> responseList = <dynamic>[];

    if (json['highscore_list'] is List<dynamic>) responseList = json['highscore_list'] as List<dynamic>;
    if (json['online_players'] is List<dynamic>) responseList = json['online_players'] as List<dynamic>;

    for (final dynamic e in responseList) {
      if (e is Map<String, dynamic>) {
        HighscoresEntry entry = HighscoresEntry.fromJson(e);
        if ((entry.level ?? 0) >= 10) {
          if (entry.expanded == null) {
            entry.expanded = ExpandedData();
            entry.expanded?.experience.value = entry.value;
            // entry.expanded?.experience.points = _getExpPointsForLevel(entry.level, entry.name);
          }
          list.add(entry);
        }
      }
    }
  }

  List<HighscoresEntry> list = <HighscoresEntry>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highscore_list'] = list.map((HighscoresEntry v) => v.toJson()).toList();
    return data.clean();
  }
}

// int _getExpPointsForLevel(int? level, String? name) {
//   double points = 0;

//   for (int i = 2; i < (level ?? 2); i++) {
//     int currentExpH = 12000 + (i * 75);
//     int expForNextLevel = ((50 * pow(i, 2)) - (150 * i) + 200).floor();
//     double hoursForNextLevel = expForNextLevel / currentExpH;
//     points += hoursForNextLevel;
//   }

//   return points.floor();
// }
