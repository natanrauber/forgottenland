import 'package:models/models.dart';
import 'package:utils/utils.dart';

class Character {
  Character();

  Character.fromJson(Map<String, dynamic> json) {
    json.clean();
    data = json['character'] != null ? CharacterData.fromJson(json['character'] as Map<String, dynamic>) : null;
    if (json['achievements'] != null && (json['achievements'] as List<dynamic>).isNotEmpty) {
      achievements = <Achievements>[];
      for (final Map<String, dynamic> v in json['achievements']) {
        achievements?.add(Achievements.fromJson(v));
      }
    }
    if (json['deaths'] != null && (json['deaths'] as List<dynamic>).isNotEmpty) {
      deaths = <Deaths>[];
      for (final Map<String, dynamic> v in json['deaths']) {
        deaths?.add(Deaths.fromJson(v));
      }
    }
    if (json['other_characters'] != null && (json['other_characters'] as List<dynamic>).isNotEmpty) {
      otherCharacters = <OtherCharacters>[];
      for (final Map<String, dynamic> v in json['other_characters']) {
        otherCharacters?.add(OtherCharacters.fromJson(v));
      }
    }
    if (json['experiencegained'] is Map<String, dynamic>) {
      experienceGained = HighscoresEntryTimeframes.fromJson(json['experiencegained'] as Map<String, dynamic>);
    }
    if (json['onlinetime'] is Map<String, dynamic>) {
      onlinetime = HighscoresEntryTimeframes.fromJson(json['onlinetime'] as Map<String, dynamic>);
    }
    if (json['rookmaster'] is Map<String, dynamic>) {
      rookmaster = HighscoresEntry.fromJson(json['rookmaster'] as Map<String, dynamic>);
    }
  }

  CharacterData? data;
  List<Achievements>? achievements;
  List<Deaths>? deaths;
  AccountInformation? accountInformation;
  List<OtherCharacters>? otherCharacters;
  HighscoresEntryTimeframes? experienceGained;
  HighscoresEntryTimeframes? onlinetime;
  HighscoresEntry? rookmaster;
}

class CharacterData {
  CharacterData({
    this.name,
    this.formerNames,
    this.title,
    this.sex,
    this.vocation,
    this.level,
    this.achievementPoints,
    this.world,
    this.residence,
    this.guild,
    this.lastLogin,
    this.comment,
    this.accountStatus,
    this.status,
  });

  CharacterData.fromJson(Map<String, dynamic> json) {
    json.clean();
    name = json['name'] as String?;
    formerNames = json['former_names'] as List<dynamic>?;
    title = json['title'] as String?;
    title = title?.split(' ').first;
    sex = json['sex'] as String?;
    vocation = json['vocation'] as String?;
    level = json['level'] as int?;
    achievementPoints = json['achievement_points'] as int?;
    world = json['world'] as String?;
    residence = json['residence'] as String?;
    if (json['guild'] != null) {
      guild = CharacterGuild.fromJson(json['guild'] as Map<String, dynamic>);
    }
    lastLogin = (json['last_login'] as String?)?.substring(0, 10);
    comment = json['comment'] as String?;
    accountStatus = json['account_status'] as String?;
    status = json['status'] as String?;
  }

  String? name;
  List<dynamic>? formerNames;
  String? title;
  String? sex;
  String? vocation;
  int? level;
  int? achievementPoints;
  String? world;
  String? residence;
  CharacterGuild? guild;
  String? lastLogin;
  String? comment;
  String? accountStatus;
  String? status;
}

class CharacterGuild {
  CharacterGuild();

  CharacterGuild.fromJson(Map<String, dynamic> json) {
    json.clean();
    name = json['name'] as String?;
    rank = json['rank'] as String?;
  }

  String? name;
  String? rank;
}

class Achievements {
  Achievements({this.grade, this.name});

  Achievements.fromJson(Map<String, dynamic> json) {
    json.clean();
    grade = json['grade'] as int?;
    name = json['name'] as String?;
  }

  int? grade;
  String? name;
}

class Deaths {
  Deaths({this.date, this.level, this.reason, this.involved});

  Deaths.fromJson(Map<String, dynamic> json) {
    json.clean();
    date = '${json['time'].substring(0, 19)}';
    level = json['level'] as int;
    reason = json['reason'] as String;
    if (json['involved'] != null && (json['involved'] as List<Map<String, dynamic>>).isNotEmpty) {
      involved = <Involved>[];
      for (final Map<String, dynamic> v in json['involved']) {
        involved?.add(Involved.fromJson(v));
      }
    }
  }

  String? date;
  int? level;
  String? reason;
  List<Involved>? involved;
}

class Involved {
  Involved({this.name});

  Involved.fromJson(Map<String, dynamic> json) {
    json.clean();
    name = json['name'] as String;
  }

  String? name;
}

class AccountInformation {
  AccountInformation({this.loyaltyTitle, this.created});

  AccountInformation.fromJson(Map<String, dynamic> json) {
    json.clean();
    loyaltyTitle = json['loyalty_title'] as String;
    created = '${json['created']['date'].substring(0, 19)} ${json['created']['timezone']}';
  }

  String? loyaltyTitle;
  String? created;
}

class OtherCharacters {
  OtherCharacters({this.name, this.world, this.status});

  OtherCharacters.fromJson(Map<String, dynamic> json) {
    json.clean();
    name = json['name'] as String;
    world = json['world'] as String;
    status = json['status'] as String;
  }

  String? name;
  String? world;
  String? status;
}

class HighscoresEntryTimeframes {
  HighscoresEntryTimeframes.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['today'] is Map) today = HighscoresEntry.fromJson(json['today'] as Map<String, dynamic>);
    if (json['yesterday'] is Map) yesterday = HighscoresEntry.fromJson(json['yesterday'] as Map<String, dynamic>);
    if (json['last7days'] is Map) last7days = HighscoresEntry.fromJson(json['last7days'] as Map<String, dynamic>);
    if (json['last30days'] is Map) last30days = HighscoresEntry.fromJson(json['last30days'] as Map<String, dynamic>);
  }

  HighscoresEntry? today;
  HighscoresEntry? yesterday;
  HighscoresEntry? last7days;
  HighscoresEntry? last30days;
}
