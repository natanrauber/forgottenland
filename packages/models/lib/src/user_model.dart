import 'package:utils/utils.dart';

class User {
  User({
    this.name,
    this.subscriber,
  });

  User.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['name'] is String) name = json['name'] as String;
    if (json['token'] is String) token = json['token'] as String;
    if (json['subscriber'] is bool) subscriber = json['subscriber'] as bool;
  }

  String? name;
  String? token;
  bool? subscriber;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['token'] = token;
    data['subscriber'] = subscriber;
    return data.clean();
  }
}
