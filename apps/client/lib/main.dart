import 'package:flutter/material.dart';
import 'package:forgottenland/forgotten_land.dart';
import 'package:forgottenland/utils/utils.dart';

Future<void> main() async {
  configureCustomPrint(CustomPrintMode.dev);
  runApp(ForgottenLand());
}
