import 'package:flutter/material.dart';
import 'package:forgottenland/forgotten_land.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  configureCustomPrint(CustomPrintMode.dev);

  await Supabase.initialize(url: PATH.database, anonKey: databaseKey);

  runApp(ForgottenLand());
}
