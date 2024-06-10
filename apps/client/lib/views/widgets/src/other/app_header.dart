import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/modules/main/app_controller.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/images/svg_image.dart';
import 'package:forgottenland/views/widgets/src/other/header_components/account_button.dart';
import 'package:forgottenland/views/widgets/src/other/header_components/share_button.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

class AppHeader extends AppBar {
  AppHeader({
    this.returnButton = true,
    this.actionButtons,
    this.screenshotCtrl,
  });

  final bool returnButton;
  final List<Widget>? actionButtons;
  final ScreenshotController? screenshotCtrl;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final AppController appCtrl = Get.find<AppController>();
  final UserController userCtrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) => AppBar(
        title: _logo(),
        automaticallyImplyLeading: false,
        leading: const AccountButton(),
        actions: <Widget>[
          ShareButton(
            screenshotCtrl: widget.screenshotCtrl,
          ),
        ],
      );

  Widget _logo() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _pushHomeScreen,
          child: const SvgImage(
            asset: 'assets/svg/logo.svg',
            height: 60,
          ),
        ),
      );

  void _pushHomeScreen() {
    if (ModalRoute.of(context)?.settings.name != Routes.home.name) Get.toNamed(Routes.home.name);
  }
}
