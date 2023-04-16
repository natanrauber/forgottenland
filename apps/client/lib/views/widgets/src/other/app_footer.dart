import 'package:flutter/material.dart';
import 'package:forgottenland/views/widgets/src/other/footer_components/card_app_info.dart';
import 'package:forgottenland/views/widgets/src/other/footer_components/card_donate.dart';

class AppFooter extends AppBar {
  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  @override
  Widget build(BuildContext context) => Column(
        children: const <Widget>[
          //
          SizedBox(height: 20),

          CardDonate(),

          SizedBox(height: 20),

          CardAppInfo(),

          SizedBox(height: 20),
        ],
      );
}
