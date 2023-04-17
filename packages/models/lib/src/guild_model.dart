import 'package:utils/utils.dart';

class Guild {
  Guild({
    this.name,
    this.description,
    this.guildhall,
    this.application,
    this.war,
    this.onlineStatus,
    this.offlineStatus,
    this.disbanded,
    this.totalmembers,
    this.totalinvited,
    this.world,
    this.founded,
    this.age,
    this.tibianAge,
    this.active,
    this.homepage,
    this.guildlogo,
    this.ranks,
    this.memberCount = 0,
    this.rookerCount = 0,
    this.highestLevel,
    this.lowestLevel,
    this.avgLevel,
    this.rookerGuild,
  });

  Guild.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['guild']['members'] != null) {
      ranks = <GuildRank>[];
      for (final Map<String, dynamic> v in json['guild']['members']) {
        ranks?.add(GuildRank.fromJson(v));
      }
    }
    if (json['guild']['data'] != null) {
      json = json['guild']['data'] as Map<String, dynamic>;
      name = json['name'] as String;
      description = json['description'] as String;
      guildhall = json['guildhall'] is Map<String, dynamic>
          ? Guildhall.fromJson(json['guildhall'] as Map<String, dynamic>)
          : null;
      application = json['application'] as bool;
      war = json['war'] as bool;
      onlineStatus = json['online_status'] as int;
      offlineStatus = json['offline_status'] as int;
      disbanded = json['disbanded'] is bool ? json['disbanded'] as bool : null;
      totalmembers = json['totalmembers'] as int;
      totalinvited = json['totalinvited'] as int;
      world = json['world'] as String;
      founded = json['founded'] as String;
      active = json['active'] as bool;
      homepage = json['homepage'] as String;
      guildlogo = json['guildlogo'] as String;

      /// calc age
      final DateTime? date = DateTime.tryParse(founded ?? '');
      int totalDays = (date?.difference(DateTime.now()).inDays ?? 0) * -1;
      int years = int.parse((totalDays / 365).toString().split('.').first);
      final int months = int.parse(
        ((totalDays % 365) / 30).toString().split('.').first,
      );
      age = '$years ${years == 1 ? 'year' : 'years'} and $months ${months == 1 ? 'month' : 'months'}';

      /// calc tibian age
      totalDays = totalDays * 24;
      years = int.parse((totalDays / 365).toString().split('.').first);
      tibianAge = '$years years';

      /// calc total members, rooker members, highest level and lowest level
      for (final GuildRank rank in ranks ?? <GuildRank>[]) {
        for (final GuildMember member in rank.members ?? <GuildMember>[]) {
          memberCount++;
          if (member.vocation == 'None') {
            rookerCount++;
            avgLevel = (avgLevel ?? 0) + (member.level ?? 0);
            if ((member.level ?? 0) > (highestLevel ?? 0)) {
              highestLevel = member.level;
            }
            if (lowestLevel == null || (member.level ?? 0) < (lowestLevel ?? 0)) {
              lowestLevel = member.level;
            }
          }
        }
      }

      /// calc average level
      if (rookerCount > 0) {
        avgLevel = (avgLevel ?? 0) / rookerCount;
      }

      /// apply filters for rooker guild
      if (rookerCount >= 5 && rookerCount >= (memberCount / 2) && (avgLevel ?? 0) > 10) {
        rookerGuild = true;
      } else {
        rookerGuild = false;
      }
    }
  }

  String? name;
  String? description;
  Guildhall? guildhall;
  bool? application;
  bool? war;
  int? onlineStatus;
  int? offlineStatus;
  bool? disbanded;
  int? totalmembers;
  int? totalinvited;
  String? world;
  String? founded;
  String? age;
  String? tibianAge;
  bool? active;
  String? homepage;
  String? guildlogo;
  List<GuildRank>? ranks;
  int memberCount = 0;
  int rookerCount = 0;
  int? highestLevel;
  int? lowestLevel;
  double? avgLevel;
  bool? rookerGuild;
}

class Guildhall {
  Guildhall({this.name, this.town, this.paid, this.world, this.houseid});

  Guildhall.fromJson(Map<String, dynamic> json) {
    json.clean();
    name = json['name'] as String;
    town = json['town'] as String;
    paid = json['paid'] as String;
    world = json['world'] as String;
    houseid = json['houseid'] as int;
  }

  String? name;
  String? town;
  String? paid;
  String? world;
  int? houseid;
}

class GuildRank {
  GuildRank({this.rankTitle, this.members});

  GuildRank.fromJson(Map<String, dynamic> json) {
    json.clean();
    rankTitle = json['rank_title'] as String;
    if (json['characters'] != null) {
      members = <GuildMember>[];

      for (final Map<String, dynamic> v in json['characters']) {
        members?.add(GuildMember.fromJson(v));
      }
    }
  }

  String? rankTitle;
  List<GuildMember>? members;
}

class GuildMember {
  GuildMember({
    this.name,
    this.nick,
    this.level,
    this.vocation,
    this.joined,
    this.status,
  });

  GuildMember.fromJson(Map<String, dynamic> json) {
    json.clean();
    name = json['name'] as String;
    nick = json['nick'] as String;
    level = json['level'] as int;
    vocation = json['vocation'] as String;
    joined = json['joined'] as String;
    status = json['status'] as String;
  }

  String? name;
  String? nick;
  int? level;
  String? vocation;
  String? joined;
  String? status;
}
