import 'package:utils/utils.dart';

class Supporter {
  Supporter({
    this.name,
    this.title,
  });

  Supporter.fromJson(Map<String, dynamic> json) {
    json.clean();
    if (json['name'] is String) name = json['name'] as String;
    if (json['title'] is String) title = json['title'] as String;
  }

  String? name;
  String? title;
}
