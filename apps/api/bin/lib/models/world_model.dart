class World {
  World({this.name});

  World.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
  }

  String? name;

  @override
  String toString() => '$name';
}
