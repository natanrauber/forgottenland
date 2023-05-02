import 'package:database_client/database_client.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/controllers/guilds_controller.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/news_controller.dart';
import 'package:forgottenland/controllers/online_controller.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:get/get.dart';
import 'package:http_client/http_client.dart';

class MainBinding implements Bindings {
  final IDatabaseClient _databaseClient = MySupabaseClient();
  final IHttpClient _httpClient = MyDioClient();

  @override
  void dependencies() {
    Get.put(UserController(_httpClient));
    Get.put(NewsController(_httpClient));
    Get.put(CharacterController(_httpClient));
    Get.put(WorldsController(_httpClient));
    Get.put(GuildsController(_httpClient));
    Get.put(OnlineController(_httpClient));
    Get.put(HighscoresController(_databaseClient, _httpClient));
  }
}
