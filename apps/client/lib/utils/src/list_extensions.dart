
import 'package:models/models.dart';

extension ListExtension on List<World> {
  World? getByName(String? name) {
    if (name == null) return null;
    if (!any((World w) => w.name?.toLowerCase() == name.toLowerCase())) return null;
    return firstWhere((World w) => w.name?.toLowerCase() == name.toLowerCase());
  }
}
