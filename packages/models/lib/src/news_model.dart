import 'package:utils/utils.dart';

class News {
  News({
    this.id,
    this.date,
    this.news,
    this.category,
    this.type,
    this.url,
  });

  News.fromJson(Map<String, dynamic> json) {
    json.clean();
    id = json['id'] as int?;
    date = json['date'] as String?;
    news = json['news'] as String?;
    category = json['category'] as String?;
    type = json['type'] as String?;
    url = json['url'] as String?;
  }

  int? id;
  String? date;
  String? news;
  String? category;
  String? type;
  String? url;
}
