import 'package:models/src/highscores_entry_model.dart';
import 'package:utils/utils.dart';

class Record {
  Record({this.list = const <HighscoresEntry>[]});

  Record.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['highscore_list'] is List<dynamic>) {
      for (final dynamic e in json['highscore_list']) {
        if (e is Map<String, dynamic>) list.add(HighscoresEntry.fromJson(e));
      }
    } else if (json['online_players'] is List<dynamic>) {
      for (final dynamic e in json['online_players']) {
        if (e is Map<String, dynamic>) list.add(HighscoresEntry.fromJson(e));
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
        if (entry.expanded == null) {
          entry.expanded = ExpandedData();
          entry.expanded?.experience.value = entry.value;
          entry.expanded?.experience.points = ((entry.value ?? 0) / 30000).floor();
          entry.expanded?.points = entry.expanded?.experience.points ?? 0;
        }
        list.add(entry);
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
