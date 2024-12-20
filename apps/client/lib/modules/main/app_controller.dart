// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/modules/splash/splash_page.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class AppController extends Controller {
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

  Future<void> copyUrl() async {
    final String url = Uri.base.toString();
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar(
      'Copied to clipboard',
      url,
      backgroundColor: AppColors.bgPaper,
      colorText: AppColors.textPrimary,
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
    );
  }

  Future<void> shareScreenshot(ScreenshotController screenshotCtrl) async {
    isLoading.value = true;
    final Uint8List? bytes = await screenshotCtrl.capture();
    if (bytes == null) return;
    final XFile image = XFile.fromData(bytes);
    final AnchorElement anchorElement = AnchorElement(href: image.path);
    anchorElement.download = _screenshotName;
    anchorElement.click();
    isLoading.value = false;
  }

  String get _screenshotName {
    String route = Get.currentRoute;
    if (route.contains('home')) return 'forgottenland.png';
    if (route.contains('highscores')) route = route.replaceAll('/highscores', '');
    return 'forgottenland$route.png';
  }
}
