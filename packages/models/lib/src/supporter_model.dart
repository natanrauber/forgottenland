class Supporter {
  Supporter({
    this.name,
    this.title,
  });

  Supporter.fromJson(Map<String, dynamic> json) {
    if (json['name'] is String) name = json['name'] as String;
    if (json['title'] is String) title = json['title'] as String;
  }

  String? name;
  String? title;
}
