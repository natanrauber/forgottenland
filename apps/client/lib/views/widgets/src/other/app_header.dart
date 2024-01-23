import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/modules/settings/controllers/settings_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/images/svg_image.dart';
import 'package:get/get.dart';

class AppHeader extends AppBar {
  AppHeader({this.returnButton = true, this.actionButtons});

  final bool returnButton;
  final List<Widget>? actionButtons;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final UserController userCtrl = Get.find<UserController>();
  final SettingsController settingsCtrl = Get.find<SettingsController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userCtrl.retrieveSession();
      settingsCtrl.getFeatures();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AppBar(
        title: _logo(),
        automaticallyImplyLeading: false,
        actions: <Widget>[_loginButton()],
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

  Future<void> _pushHomeScreen() async {
    if (ModalRoute.of(context)?.settings.name != Routes.home.name) {
      Get.toNamed(Routes.home.name);
    }
  }

  Widget _loginButton() => Obx(
        () => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _pushLoginScreen,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                userCtrl.isLoggedIn.value ? Icons.logout_rounded : Icons.login_rounded,
                color: AppColors.bgDefault,
              ),
            ),
          ),
        ),
      );

  Future<void> _pushLoginScreen() async {
    if (ModalRoute.of(context)?.settings.name != Routes.login.name) {
      Get.toNamed(Routes.login.name);
    }
  }
}
