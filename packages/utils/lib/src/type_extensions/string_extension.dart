extension StringExtension on String {
  String capitalizeString() {
    if (!contains(RegExp('[A-Z]')) && !contains(RegExp('[a-z]'))) {
      return this;
    }

    final StringBuffer buffer = StringBuffer();
    final List<String> words = split(' ');
    for (final String element in words) {
      if (element.length > 1) {
        buffer.write(
          '${element.substring(0, 1).toUpperCase()}${element.substring(1).toLowerCase()} ',
        );
      } else {
        buffer.write('${element.toUpperCase()} ');
      }
    }
    return buffer.toString().trim();
  }

  /// [clean] string
  /// * calls [trim()]
  /// * calls [removeAccent()]
  /// * calls [toUpperCase()]
  String clean() => trim().toUpperCase();
}
