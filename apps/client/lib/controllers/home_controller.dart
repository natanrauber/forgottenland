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

  Future<MyHttpResponse> getNews({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final MyHttpResponse response = await httpClient.get('${PATH.tibiaDataApi}/news/latest');

    if (response.success) {
      final List<News> aux = <News>[];
      for (final dynamic item in response.dataAsMap['news'] as List<dynamic>) {
        aux.add(News.fromJson(item as Map<String, dynamic>));
      }
      news.value = aux.toList();
    }

    isLoading.value = false;
    return response;
  }

  Future<MyHttpResponse> getOverview({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    final MyHttpResponse response = await httpClient.get('${PATH.forgottenLandApi}/highscores/overview');

    if (response.success) {
      final Overview overview = Overview.fromJson(
        (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      );
      experiencegained.value = overview.experiencegained.toList();
      onlinetime.value = overview.onlinetime.map((OnlineEntry e) => HighscoresEntry.fromOnlineEntry(e)).toList();
      rookmaster.value = overview.rookmaster.toList();
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
        getOverview(showLoading: false);
      },
    );
    Timer.periodic(
      const Duration(hours: 1),
      (_) {
        if (isLoading.value) return;
        if (Get.currentRoute != Routes.home.name) return;
        getNews(showLoading: false);
      },
    );
  }
}
