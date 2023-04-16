/// this config follows Tibia server save time to define days
class MyDateTime {
  static DateTime now() {
    final DateTime now = DateTime.now().toUtc();
    // summertime
    if (now.month >= 4 && now.month <= 10) {
      return now.subtract(const Duration(hours: 8));
    }
    return now.subtract(const Duration(hours: 9));
  }

  static String today() => now().toIso8601String().substring(0, 10);

  static String yesterday() => (now().subtract(const Duration(days: 1))).toIso8601String().substring(0, 10);

  /// returns current utc datetime formated as `yyyy-MM-ddTHH:mm:ss.mmmuuuZ`
  static String timeStamp() => now().toIso8601String();
}
