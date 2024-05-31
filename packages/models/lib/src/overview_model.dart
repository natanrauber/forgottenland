import 'package:models/models.dart';
import 'package:utils/utils.dart';

class Overview {
  Overview({
    this.experiencegained = const <HighscoresEntry>[],
    this.onlinetime = const <OnlineEntry>[],
    this.rookmaster = const <HighscoresEntry>[],
    this.experience = const <HighscoresEntry>[],
    this.timestamp,
  });

  Overview.fromJson(Map<String, dynamic> json) {
    json.clean();

    List<dynamic> listExp = <dynamic>[];
    List<dynamic> listOnline = <dynamic>[];
    List<dynamic> listRookmaster = <dynamic>[];
    List<dynamic> listExperience = <dynamic>[];

    if (json['experiencegained'] is List<dynamic>) listExp = json['experiencegained'] as List<dynamic>;
    for (final dynamic e in listExp) {
      if (e is Map<String, dynamic>) {
        HighscoresEntry entry = HighscoresEntry.fromJson(e);
        if ((entry.level ?? 0) >= 10) experiencegained.add(entry);
      }
    }

    if (json['onlinetime'] is List<dynamic>) listOnline = json['onlinetime'] as List<dynamic>;
    for (final dynamic e in listOnline) {
      if (e is Map<String, dynamic>) {
        OnlineEntry entry = OnlineEntry.fromJson(e);
        if ((entry.level ?? 0) >= 10) onlinetime.add(entry);
      }
    }

    if (json['rookmaster'] is List<dynamic>) listRookmaster = json['rookmaster'] as List<dynamic>;
    for (final dynamic e in listRookmaster) {
      if (e is Map<String, dynamic>) {
        HighscoresEntry entry = HighscoresEntry.fromJson(e);
        if ((entry.level ?? 0) >= 10) rookmaster.add(entry);
      }
    }

    if (json['experience'] is List<dynamic>) listExperience = json['experience'] as List<dynamic>;
    for (final dynamic e in listExperience) {
      if (e is Map<String, dynamic>) {
        HighscoresEntry entry = HighscoresEntry.fromJson(e);
        if ((entry.level ?? 0) >= 10) experience.add(entry);
      }
    }
  }

  List<HighscoresEntry> experiencegained = <HighscoresEntry>[];
  List<OnlineEntry> onlinetime = <OnlineEntry>[];
  List<HighscoresEntry> rookmaster = <HighscoresEntry>[];
  List<HighscoresEntry> experience = <HighscoresEntry>[];
  String? timestamp;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['experiencegained'] = experiencegained.map((HighscoresEntry v) => v.toJson()).toList();
    data['onlinetime'] = onlinetime.map((OnlineEntry v) => v.toJson()).toList();
    data['rookmaster'] = rookmaster.map((HighscoresEntry v) => v.toJson()).toList();
    data['experience'] = experience.map((HighscoresEntry v) => v.toJson()).toList();
    return data.clean();
  }
}
