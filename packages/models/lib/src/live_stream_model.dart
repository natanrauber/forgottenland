import 'package:utils/utils.dart';

class LiveStream {
  LiveStream();

  LiveStream.fromJson(Map<String, dynamic> json) {
    if (json['user_name'] is String) userName = json['user_name'] as String;
    if (json['title'] is String) title = json['title'] as String;
    if (json['thumbnail_url'] is String) {
      thumbUrl = (json['thumbnail_url'] as String).replaceAll('{width}', '1920').replaceAll('{height}', '1080');
    }
    if (json['viewer_count'] is int) viewerCount = json['viewer_count'] as int;
    if (json['tags'] is List) {
      for (var e in json['tags'] as List) {
        if (e is String) tags.add(e);
      }
    }
  }

  String? userName;
  String? title;
  String? thumbUrl;
  int? viewerCount;
  List<String> tags = <String>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_name'] = userName;
    data['title'] = title;
    data['thumbnail_url'] = thumbUrl;
    data['viewer_count'] = viewerCount;
    data['tags'] = tags;
    return data.clean();
  }

  contains(String text) {
    if (title != null && title!.toLowerCase().contains(text.toLowerCase())) return true;
    for (String tag in tags) {
      if (tag.toLowerCase().contains(text.toLowerCase())) return true;
    }
    return false;
  }
}
