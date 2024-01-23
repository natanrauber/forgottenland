import 'package:database_client/database_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/controllers/guilds_controller.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/news_controller.dart';
import 'package:forgottenland/controllers/online_controller.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:forgottenland/modules/bazaar/controllers/bazaar_controller.dart';
import 'package:forgottenland/modules/main/controllers/main_controller.dart';
import 'package:forgottenland/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';
import 'package:http_client/http_client.dart';

class MainBinding implements Bindings {
  final IDatabaseClient _databaseClient = MySupabaseClient();
  final IHttpClient _httpClient = MyDioClient(postRequestCallback: _postRequestCallback);

  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(UserController(_httpClient));
    Get.put(NewsController(_httpClient));
    Get.put(CharacterController(_httpClient));
    Get.put(WorldsController(_httpClient));
    Get.put(GuildsController(_httpClient));
    Get.put(OnlineController(_httpClient));
    Get.put(HighscoresController(_databaseClient, _httpClient));
    Get.put(BazaarController(httpClient: _httpClient, worldsCtrl: Get.find<WorldsController>()));
    Get.put(SettingsController(_httpClient));
  }
}

Future<void> _postRequestCallback(MyHttpResponse response) async => FirebaseAnalytics.instance.logEvent(
      name:
          '${response.statusCode} ${response.requestOptions?.path.replaceAll('//', '').replaceFirst('/', 'SPLIT').split('SPLIT').last}',
      parameters: <String, dynamic>{
        'data': response.dataAsMap.toString(),
      },
    );
