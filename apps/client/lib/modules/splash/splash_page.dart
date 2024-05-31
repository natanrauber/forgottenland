import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:forgottenland/modules/main/controllers/main_controller.dart';
import 'package:forgottenland/modules/settings/controllers/settings_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/app_header.dart';
import 'package:get/get.dart';

class SplashPageArguments {
  const SplashPageArguments({required this.redirectRoute});
  final String redirectRoute;
}

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashPageArguments? args;

  final MainController mainCtrl = Get.find<MainController>();
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final UserController userCtrl = Get.find<UserController>();
  final SettingsController settingsCtrl = Get.find<SettingsController>();
  final WorldsController worldsCtrl = Get.find<WorldsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        args = Get.arguments as SplashPageArguments?;
        // ignore: use_build_context_synchronously
        await highscoresCtrl.preCacheImages(context);
        await userCtrl.retrieveSession();
        await settingsCtrl.getFeatures();
        await worldsCtrl.getWorlds();
        _redirect();
      },
    );
  }

  void _redirect() {
    mainCtrl.visitedSplash = true;
    Get.offNamed(args?.redirectRoute ?? Routes.home.name);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppHeader(),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: _backgroundDecoration,
          child: _loading(),
        ),
      );

  BoxDecoration get _backgroundDecoration => const BoxDecoration(
        color: AppColors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/background/offline.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      );

  Widget _loading() => Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(37.5),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );
}
