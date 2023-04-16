import 'package:models/src/highscores_entry_model.dart';

class Record {
  Record({
    this.highscoreList = const <HighscoresEntry>[],
  });

  Record.fromJson(Map<String, dynamic> json) {
    if (json['highscore_list'] is! List<dynamic>) return;

    for (final dynamic e in json['highscore_list']) {
      if (e is Map<String, dynamic>) highscoreList.add(HighscoresEntry.fromJson(e));
    }
  }

  List<HighscoresEntry> highscoreList = <HighscoresEntry>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highscore_list'] = highscoreList.map((HighscoresEntry v) => v.toJson()).toList();
    return data;
  }
}
