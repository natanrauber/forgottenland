class NPC {
  NPC.fromJson(Map<String, dynamic> json) {
    if (json['path'] is String) {
      name = (json['path'] as String).split('/').lastOrNull?.split('.').firstOrNull?.replaceAll('_', ' ');
    }
    imgUrl = 'https://raw.githubusercontent.com/s2ward/tibia/main/images/npcs/${name?.replaceAll(' ', '_')}.png';
  }

  String? name;
  String? imgUrl;
  String? transcripts;

  void updateFromJson(Map<String, dynamic> json) {
    if (json['data'] is String) transcripts = json['data'] as String;
  }
}
