class World {
  World({
    this.name,
    this.status,
    this.playersOnline,
    this.location,
    this.pvpType,
    this.premiumOnly,
    this.transferType,
    this.battleyeProtected,
    this.battleyeType,
    this.worldType,
    this.tournamentWorldType,
  });

  World.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    status = json['status'] as String?;
    playersOnline = json['players_online'] as int?;
    location = json['location'] as String?;
    pvpType = json['pvp_type'] as String?;
    premiumOnly = json['premium_only'] as bool?;
    transferType = json['transfer_type'] as String?;
    battleyeProtected = json['battleye_protected'] as bool?;
    battleyeType = battleyeProtected == true
        ? (json['battleye_date'] as String?) == 'release'
            ? 'Green'
            : 'Yellow'
        : 'None';
    worldType = json['game_world_type'] as String?;
    tournamentWorldType = json['tournament_world_type'] as String?;
  }

  String? name;
  String? status;
  int? playersOnline;
  String? location;
  String? pvpType;
  bool? premiumOnly;
  String? transferType;
  bool? battleyeProtected;
  String? battleyeType;
  String? worldType;
  String? tournamentWorldType;

  @override
  String toString() => '$name';
}
