import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/modules/splash/splash_page.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:get/get.dart';

class MainController extends Controller {
  bool visitedSplash = false;

  void ensureSplashIsVisited() {
    if (visitedSplash == false) {
      Get.offNamed(
        Routes.splash.name,
        arguments: SplashPageArguments(
          redirectRoute: Get.currentRoute,
        ),
      );
    }
  }
}
