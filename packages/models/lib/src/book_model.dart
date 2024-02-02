class Book {
  Book.fromJson(Map<String, dynamic> json) {
    if (json['name'] is String) name = (json['name'] as String).replaceAll('_', ' ');
    if (json['author'] is String) author = json['author'] as String;
    if (json['description'] is String) description = json['description'] as String;
    if (json['related-articles'] is List<dynamic>) {
      for (dynamic e in json['related-articles'] as List<dynamic>) {
        if (e is Map<String, dynamic>) relatedArticles.add(Article.fromJson(e));
      }
    }
    if (json['img'] is List<dynamic>) {
      for (dynamic e in json['img'] as List<dynamic>) {
        if (e is String) sprites.add(e);
      }
    }
    if (json['text'] is String) text = json['text'] as String;
    if (json['map'] is List<dynamic>) {
      for (dynamic e in json['map'] as List<dynamic>) {
        if (e is String) map.add(e);
      }
    }
    if (json['type'] is String) type = json['type'] as String;
    if (json['locations-wip'] is List<dynamic>) {
      for (dynamic e in json['locations-wip'] as List<dynamic>) {
        if (e is Map<String, dynamic>) locations.add(BookLocation.fromJson(e));
      }
    }
  }

  String? name;
  String? author;
  String? description;
  List<Article> relatedArticles = <Article>[];
  List<String> sprites = <String>[];
  String? text;
  List<String> map = <String>[];
  String? type;
  List<BookLocation> locations = <BookLocation>[];
}

class Article {
  Article.fromJson(Map<String, dynamic> json) {
    if (json['article-name'] is String) name = json['article-name'] as String;
    if (json['article-url'] is String) url = json['article-url'] as String;
  }

  String? name;
  String? url;
}

class BookLocation {
  BookLocation.fromJson(Map<String, dynamic> json) {
    if (json['mainarea'] is String) mainArea = json['mainarea'] as String;
    if (json['area'] is String) area = json['area'] as String;
    if (json['subarea'] is String) subArea = json['subarea'] as String;
  }

  String? mainArea;
  String? area;
  String? subArea;
}
