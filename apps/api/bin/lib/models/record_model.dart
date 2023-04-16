class Record {
  Record({
    this.highscoreList = const <HighscoreEntry>[],
  });

  Record.fromJson(Map<String, dynamic> json) {
    if (json['highscore_list'] is! List<dynamic>) return;

    for (final dynamic e in json['highscore_list']) {
      if (e is Map<String, dynamic>) highscoreList.add(HighscoreEntry.fromJson(e));
    }
  }

  List<HighscoreEntry> highscoreList = <HighscoreEntry>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highscore_list'] = highscoreList.map((HighscoreEntry v) => v.toJson()).toList();
    return data;
  }
}

class HighscoreEntry {
  HighscoreEntry({this.rank, this.name, this.vocation, this.world, this.level, this.value});

  HighscoreEntry.fromJson(Map<String, dynamic> json) {
    if (json['rank'] is int) rank = json['rank'] as int;
    if (json['name'] is String) name = json['name'] as String;
    if (json['vocation'] is String) vocation = json['vocation'] as String;
    if (json['world'] is String) world = json['world'] as String;
    if (json['level'] is int) level = json['level'] as int;
    if (json['value'] is int) value = json['value'] as int;
  }

  int? rank;
  String? name;
  String? vocation;
  String? world;
  int? level;
  int? value;

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
