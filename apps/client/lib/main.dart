import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forgottenland/forgotten_land.dart';
import 'package:forgottenland/utils/utils.dart';

Future<void> main() async {
  configureCustomPrint(CustomPrintMode.dev);
  await dotenv.load();
  runApp(ForgottenLand());
}
