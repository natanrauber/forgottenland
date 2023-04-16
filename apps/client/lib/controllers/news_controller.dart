import 'package:dio/dio.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/http.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:models/models.dart';

class NewsController extends Controller {
  RxList<News> list = <News>[].obs;

  Future<Response<dynamic>?> getNews() async {
    Response<dynamic>? response;

    isLoading.value = true;
    response = await Http().get('/news/latest');

    if (response?.data is Map<String, dynamic>) {
      for (final dynamic item in response?.data['news'] as List<dynamic>) {
        list.add(News.fromJson(item as Map<String, dynamic>));
      }
    }

    isLoading.value = false;
    return response;
  }
}
