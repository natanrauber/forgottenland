import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/modules/main/controllers/main_controller.dart';
import 'package:forgottenland/modules/settings/controllers/settings_controller.dart';
import 'package:forgottenland/modules/settings/models/feature_model.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/app_footer.dart';
import 'package:forgottenland/views/widgets/src/other/app_header.dart';
import 'package:get/get.dart';

class AppPage extends StatefulWidget {
  const AppPage({
    required this.screenName,
    this.body,
    this.postFrameCallback,
    this.onRefresh,
    this.onNotification,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 60),
    this.canPop = true,
    this.maxWidth = 800,
  });

  final String screenName;
  final Widget? body;
  final Future<void> Function()? postFrameCallback;
  final Future<void> Function()? onRefresh;
  final bool Function(ScrollNotification)? onNotification;
  final EdgeInsetsGeometry? padding;
  final bool canPop;
  final double maxWidth;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  MainController mainCtrl = Get.find<MainController>();
  SettingsController settingsCtrl = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainCtrl.ensureSplashIsVisited();
      if (mainCtrl.visitedSplash) {
        _logScreenEvent();
        if (!_featureDisabled) widget.postFrameCallback?.call();
      }
    });
  }

  void _logScreenEvent() => FirebaseAnalytics.instance.logEvent(name: 'page_${widget.screenName}');

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double appBarHeight = AppHeader().preferredSize.height;
    double topMargin = height > 700 ? height - 700 : 0;
    if (topMargin > height * 0.18) topMargin = height * 0.18;
    if (width <= 800) topMargin = 0;
    final double sideMargin = width > widget.maxWidth ? ((width / 2) - (widget.maxWidth / 2)) + 0 : 0;

    return PopScope(
      canPop: widget.canPop,
      child: GestureDetector(
        onTap: () => dismissKeyboard(context),
        child: Scaffold(
          appBar: AppHeader(),
          body: Container(
            height: height,
            width: width,
            decoration: _backgroundDecoration,
            child: RefreshIndicator(
              onRefresh: widget.onRefresh ?? () async {},
              child: NotificationListener<ScrollNotification>(
                onNotification: widget.onNotification,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    //
                    Container(
                      constraints: BoxConstraints(minHeight: height - appBarHeight - topMargin),
                      margin: EdgeInsets.fromLTRB(sideMargin, topMargin * 2, sideMargin, 0),
                      decoration: _bodyDecoration,
                    ),

                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(sideMargin, topMargin, sideMargin, 0),
                        decoration: _bodyDecoration,
                        child: Column(
                          children: <Widget>[
                            //
                            SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: widget.padding,
                              child: Container(
                                constraints: _bodyConstraints,
                                child: _featureDisabled ? _disabledPageBody() : widget.body,
                              ),
                            ),

                            AppFooter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _featureDisabled {
    final String? routeName = Get.rawRoute?.settings.name?.toLowerCase();
    for (final Feature e in settingsCtrl.features) {
      if (e.name != null && routeName?.contains(e.name!.toLowerCase()) == true && !e.enabled) return true;
    }
    return false;
  }

  Widget _disabledPageBody() => Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SelectableText.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  fontWeight: FontWeight.w200,
                  color: AppColors.textSecondary,
                ),
                children: <InlineSpan>[
                  //
                  const TextSpan(
                    text: 'Feature temporarily disabled\n',
                  ),

                  TextSpan(
                    text: 'Go to homepage',
                    style: const TextStyle(
                      color: AppColors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blue,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.home.name),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  BoxDecoration get _backgroundDecoration => const BoxDecoration(
        color: AppColors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/background/offline.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      );

  BoxDecoration get _bodyDecoration {
    double height;
    double width;
    double topMargin;
    double sideMargin;
    double borderRadius;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    topMargin = height > 700 ? height - 700 : 0;
    if (topMargin > height * 0.18) topMargin = height * 0.18;
    sideMargin = width > 800 ? ((width / 2) - 400) + 0 : 0;
    borderRadius = (topMargin > 0 && sideMargin > 0) ? 11 : 0;

    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
      color: AppColors.bgDefault,
    );
  }

  BoxConstraints get _bodyConstraints {
    double height;
    double width;
    double appBarHeight;
    double topMargin;
    double verticalPadding;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    appBarHeight = AppHeader().preferredSize.height;
    topMargin = height > 700 ? height - 700 : 0;
    if (topMargin > height * 0.18) topMargin = height * 0.18;
    if (width <= 800) topMargin = 0;
    verticalPadding = widget.padding?.along(Axis.vertical) ?? 0;

    return BoxConstraints(
      minHeight: height - appBarHeight - topMargin - verticalPadding,
    );
  }
}
