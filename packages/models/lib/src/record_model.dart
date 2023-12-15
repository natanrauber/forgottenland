import 'package:models/src/highscores_entry_model.dart';
import 'package:utils/utils.dart';

class Record {
  Record({
    this.list = const <HighscoresEntry>[],
    this.timestamp,
  });

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
          }
          list.add(entry);
        }
      }
    }
  }

  List<HighscoresEntry> list = <HighscoresEntry>[];
  String? timestamp;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['highscore_list'] = list.map((HighscoresEntry v) => v.toJson()).toList();
    return data.clean();
  }
}
