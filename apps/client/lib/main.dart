import 'package:flutter/material.dart';
import 'package:forgottenland/forgotten_land.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

String appVersion = '';

Future<void> main() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
  configureCustomPrint(CustomPrintMode.dev);
  runApp(ForgottenLand());
}
