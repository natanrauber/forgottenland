import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/firebase_options.dart';
import 'package:forgottenland/forgotten_land.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:utils/utils.dart';

String appVersion = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
  await _initializeFirebase();
  runApp(ForgottenLand());
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  customPrint('Firebase projectId: ${DefaultFirebaseOptions.currentPlatform.projectId}');
  await FirebaseAnalytics.instance.logAppOpen();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
