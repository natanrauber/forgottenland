class WorldGuilds {
  WorldGuilds({this.guilds});

  WorldGuilds.fromJson(Map<String, dynamic> json) {
    guilds = json['guilds'] != null ? Guilds.fromJson(json['guilds'] as Map<String, dynamic>) : null;
  }

  Guilds? guilds;
}

class Guilds {
  Guilds({this.world, this.active});

  Guilds.fromJson(Map<String, dynamic> json) {
    world = json['world'] as String;
    if (json['active'] != null) {
      active = <Active>[];

      for (final Map<String, dynamic> v in json['active']) {
        active?.add(Active.fromJson(v));
      }
    }
  }

  String? world;
  List<Active>? active;
}

class Active {
  Active({this.name, this.desc, this.guildlogo});

  Active.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    desc = json['desc'] as String;
    guildlogo = json['guildlogo'] as String;
  }

  String? name;
  String? desc;
  String? guildlogo;
}
