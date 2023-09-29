import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forgottenland/modules/main/controllers/main_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/app_header.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplashPageArguments {
  const SplashPageArguments({required this.redirectRoute});
  final String redirectRoute;
}

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashPageArguments? args;
  MainController mainCtrl = Get.find<MainController>();

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        args = Get.arguments as SplashPageArguments?;
        visible = true;
        await Future<dynamic>.delayed(const Duration(seconds: 3), () => visible = false);
        await Future<dynamic>.delayed(const Duration(seconds: 1), _redirect);
      },
    );
  }

  bool get visible => _visible;
  set visible(bool value) => setState(() => _visible = value);

  void _redirect() {
    mainCtrl.visitedSplash = true;
    Get.offNamed(args?.redirectRoute ?? Routes.home.name);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppHeader(),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: _backgroundDecoration,
          child: _sponsor(),
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

  Widget _sponsor() => AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => launchUrlString(
              'https://www.instagram.com/merighitintas',
              mode: LaunchMode.externalApplication,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _sponsorText(),
                const SizedBox(height: 20),
                _sponsorImage(),
                const SizedBox(height: 20),
                _sponsorInstagramButton(),
              ],
            ),
          ),
        ),
      );

  Widget _sponsorText() => const Text(
        'Sponsored by:',
        style: TextStyle(fontSize: 18),
      );

  Widget _sponsorImage() => ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          color: Colors.red,
          child: Image.asset(
            'assets/images/splash/tintas_merighi.jpeg',
          ),
        ),
      );

  Widget _sponsorInstagramButton() => Container(
        width: MediaQuery.of(context).size.width - 40 > 400 ? 400 : MediaQuery.of(context).size.width - 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.bgDefault,
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'View on Instagram',
              style: TextStyle(
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 20),
            Icon(
              FontAwesomeIcons.instagram,
              color: AppColors.primary,
            ),
          ],
        ),
      );
}
