import 'package:utils/utils.dart';

class User {
  User({
    this.name,
    this.subscriber,
  });

  User.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['char_name'] is String) name = json['char_name'] as String;
    if (json['subscriber'] is bool) subscriber = json['subscriber'] as bool;
  }

  String? name;
  bool? subscriber;
}
