import 'package:flutter/material.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_runTimer);
  }

  void _runTimer(_) => Future<dynamic>.delayed(const Duration(seconds: 3), _pushHomeScreen);

  void _pushHomeScreen() => Get.toNamed(Routes.home.name);

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: ColoredBox(
            color: Colors.red,
            child: Image.asset(
              'assets/images/splash/tintas_merighi.jpeg',
            ),
          ),
        ),
      );
}
