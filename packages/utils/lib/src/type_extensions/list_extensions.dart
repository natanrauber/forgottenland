import 'package:models/models.dart';

extension WorldListExtension on List<World> {
  World? getByName(String? name) {
    if (name == null) return null;
    if (!any((World w) => w.name?.toLowerCase() == name.toLowerCase())) return null;
    return firstWhere((World w) => w.name?.toLowerCase() == name.toLowerCase());
  }
}

extension ListExtension on List<dynamic> {
  List<T> getSegment<T>({required int size, required int index}) {
    if (runtimeType != List<T>) {
      print('list.getSegment called with wrong type [$runtimeType, List<$T>]');
      return <T>[];
    }
    if (index * size > length) return <T>[];
    if (length <= size) return this as List<T>;

    int start = index * size;
    int end = index + 1 * size;
    if (end > length) end = length;
    return getRange(start, end).toList() as List<T>;
  }
}
