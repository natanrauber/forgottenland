// ignore_for_file: always_specify_types

extension MapExtension on Map<String, dynamic> {
  /// [clean] Map<String, dynamic>
  /// * trim strings
  /// * remove empty strings
  /// * remove null fields
  /// * remove empty lists
  /// * calls clean() on submaps
  /// * remove empty maps
  Map<String, dynamic> clean() {
    final List<Map<String, dynamic>> toClean = <Map<String, dynamic>>[];
    final List<String> toRemove = <String>[];

    for (final String key in keys) {
      if (this[key] is String) this[key] = this[key].trim();
      if (this[key] is String && this[key] == '') toRemove.add(key);
      if (this[key] == null) toRemove.add(key);
      if (this[key] is List && (this[key] as List).isEmpty) toRemove.add(key);
      if (this[key] is Map<String, dynamic>) {
        toClean.add(this[key] as Map<String, dynamic>);
      }
    }

    for (final Map<String, dynamic> map in toClean) {
      map.clean();
    }

    for (final String key in keys) {
      if (this[key] is Map && (this[key] as Map).isEmpty) toRemove.add(key);
    }

    for (final String key in toRemove) {
      remove(key);
    }
    return this;
  }
}
