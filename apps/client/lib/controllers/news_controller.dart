import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';

class NewsController extends Controller {
  RxList<News> list = <News>[].obs;

  Future<MyHttpResponse> getNews() async {
    MyHttpResponse response;

    isLoading.value = true;
    response = await MyHttpClient().get('${PATH.tibiaDataApi}/news/latest');

    if (response.success) {
      for (final dynamic item in response.dataAsMap['news'] as List<dynamic>) {
        list.add(News.fromJson(item as Map<String, dynamic>));
      }
    }

    isLoading.value = false;
    return response;
  }
}
