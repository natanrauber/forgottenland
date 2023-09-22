import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/firebase_options.dart';
import 'package:forgottenland/forgotten_land.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

String appVersion = '';

Future<void> main() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
  configureCustomPrint(CustomPrintMode.dev);
  await _initializeFirebase();
  runApp(ForgottenLand());
}

Future<void> _initializeFirebase() async {
  if (kDebugMode) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAnalytics.instance.logAppOpen();
}
