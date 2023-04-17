import 'package:utils/utils.dart';

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
    json.clean();
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['status'] = status;
    data['players_online'] = playersOnline;
    data['location'] = location;
    data['pvp_type'] = pvpType;
    data['premium_only'] = premiumOnly;
    data['transfer_type'] = transferType;
    data['battleye_protected'] = battleyeProtected;
    data['battleye_date'] = battleyeProtected == true
        ? battleyeType == 'Green'
            ? 'Release'
            : ''
        : 'None';
    data['game_world_type'] = worldType;
    data['tournament_world_type'] = tournamentWorldType;
    return data.clean();
  }
}
