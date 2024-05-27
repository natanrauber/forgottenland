import 'dart:async';

import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:get/get.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';

class HomeController extends Controller {
  HomeController(this.httpClient);

  final IHttpClient httpClient;

  RxList<News> news = <News>[].obs;
  RxList<HighscoresEntry> experiencegained = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> onlinetime = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> rookmaster = <HighscoresEntry>[].obs;

  Timer? timer;

  Future<MyHttpResponse> getNews() async {
    isLoading.value = true;
    final MyHttpResponse response = await httpClient.get('${PATH.tibiaDataApi}/news/latest');

    if (response.success) {
      for (final dynamic item in response.dataAsMap['news'] as List<dynamic>) {
        news.add(News.fromJson(item as Map<String, dynamic>));
      }
    }

    isLoading.value = false;
    return response;
  }

  Future<MyHttpResponse> getOverview() async {
    isLoading.value = true;
    experiencegained.clear();
    onlinetime.clear();

    final MyHttpResponse response = await httpClient.get('${PATH.forgottenLandApi}/highscores/overview');

    if (response.success) {
      final Overview overview = Overview.fromJson(
        (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      );
      experiencegained.addAll(overview.experiencegained);
      onlinetime.addAll(overview.onlinetime.map((OnlineEntry e) => HighscoresEntry.fromOnlineEntry(e)).toList());
      rookmaster.addAll(overview.rookmaster);
    }

    isLoading.value = false;
    return response;
  }

  void runTimer() {
    Timer.periodic(
      const Duration(minutes: 5),
      (_) {
        if (isLoading.value) return;
        if (Get.currentRoute != Routes.home.name) return;
        getOverview();
      },
    );
  }
}
