class User {
  User({
    this.name,
    this.subscriber,
  });

  User.fromJson(Map<String, dynamic> json) {
    if (json['char_name'] is String) name = json['char_name'] as String;
    if (json['subscriber'] is bool) subscriber = json['subscriber'] as bool;
  }

  String? name;
  bool? subscriber;
}
