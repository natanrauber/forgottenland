import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/controllers/guilds_controller.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/news_controller.dart';
import 'package:forgottenland/controllers/online_controller.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
    Get.put(NewsController());
    Get.put(CharacterController());
    Get.put(WorldsController());
    Get.put(GuildsController());
    Get.put(OnlineController());
    Get.put(HighscoresController());
  }
}
