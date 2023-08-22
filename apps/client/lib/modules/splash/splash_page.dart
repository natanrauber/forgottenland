import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/app_header.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        visible = true;
        await Future<dynamic>.delayed(const Duration(seconds: 2), () => visible = false);
        await Future<dynamic>.delayed(const Duration(seconds: 1), _pushHomeScreen);
      },
    );
  }

  bool get visible => _visible;
  set visible(bool value) => setState(() => _visible = value);

  void _pushHomeScreen() => Get.toNamed(Routes.home.name);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppHeader(),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: _backgroundDecoration,
          child: _advertisingImage(),
        ),
      );

  BoxDecoration get _backgroundDecoration => const BoxDecoration(
        color: AppColors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/background/offline.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          // opacity: 0.7,
        ),
      );

  Widget _advertisingImage() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrlString('https://www.instagram.com/merighitintas'),
          child: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                color: Colors.red,
                child: Image.asset(
                  'assets/images/splash/tintas_merighi.jpeg',
                ),
              ),
            ),
          ),
        ),
      );
}
