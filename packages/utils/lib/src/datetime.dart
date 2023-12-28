class DT {
  static MyDateTime germany = MyDateTime(
    timeZone: isSummerTime() ? 'CEST' : 'CET',
    utcAheadAmount: isSummerTime() ? 2 : 1,
  );
  // Tibia's time is 10 hours behind Germany time
  static MyDateTime tibia = MyDateTime(
    timeZone: 'Tibia',
    utcAheadAmount: isSummerTime() ? -8 : -9,
  );

  // Summer time in Germany runs from the last Sunday in April to the last Sunday in October
  static bool isSummerTime() =>
      !DateTime.now().isBefore(_lastSundayOf(3)) && !DateTime.now().isAfter(_lastSundayOf(10));

  static DateTime _lastSundayOf(int month) {
    DateTime day = DateTime(DateTime.now().year, month + 1, 1);
    do {
      day = day.subtract(Duration(days: 1));
    } while (day.weekday != DateTime.sunday);
    return day;
  }
}

class MyDateTime {
  MyDateTime({required this.timeZone, required this.utcAheadAmount});

  late String timeZone;
  late int utcAheadAmount;

  DateTime now() {
    final DateTime now = DateTime.now().toUtc();
    return now.add(Duration(hours: utcAheadAmount));
  }

  String today() => now().toIso8601String().substring(0, 10);

  String yesterday() => (now().subtract(const Duration(days: 1))).toIso8601String().substring(0, 10);

  String aWeekAgo() => (now().subtract(const Duration(days: 7))).toIso8601String().substring(0, 10);

  String aMonthAgo() => (now().subtract(const Duration(days: 30))).toIso8601String().substring(0, 10);

  String aYearAgo() => (now().subtract(const Duration(days: 365))).toIso8601String().substring(0, 10);

  List<String> range(DateTime start, DateTime end) {
    List<String> range = <String>[];
    DateTime date = start;
    do {
      range.add(date.toIso8601String().substring(0, 10));
      date = date.add(Duration(days: 1));
    } while (date.isBefore(end));
    return range;
  }

  String timeStamp() {
    String text = _getMonthName(now().month);
    text += ' ${now().day.toString().padLeft(2, '0')}';
    text += ' ${now().year.toString().padLeft(2, '0')}';
    text += ', ${now().hour.toString().padLeft(2, '0')}';
    text += ':${now().minute.toString().padLeft(2, '0')}';
    text += ':${now().second.toString().padLeft(2, '0')}';
    text += ' $timeZone';
    return text;
  }
}

String _getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    default:
      return 'Dec';
  }
}
