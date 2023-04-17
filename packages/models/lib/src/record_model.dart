import 'package:models/src/highscores_entry_model.dart';

class Record {
  Record({this.list = const <HighscoresEntry>[]});

  Record.fromJson(Map<String, dynamic> json) {
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

  List<HighscoresEntry> list = <HighscoresEntry>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highscore_list'] = list.map((HighscoresEntry v) => v.toJson()).toList();
    return data;
  }
}
