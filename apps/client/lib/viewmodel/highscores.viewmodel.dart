import 'package:models/models.dart';

class HighscoresViewModel {
  HighscoresViewModel({
    this.category = 'Level',
    this.world,
    this.battleyeType,
  });

  String? category;
  World? world = World(name: 'All');
  String? battleyeType;
}
