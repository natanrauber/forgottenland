import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/app_footer.dart';
import 'package:forgottenland/views/widgets/src/other/app_header.dart';

class AppPage extends StatefulWidget {
  const AppPage({
    super.key,
    this.body,
    this.onRefresh,
    this.onNotification,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 60),
    this.canPop = true,
  });

  final Widget? body;
  final Future<void> Function()? onRefresh;
  final bool Function(ScrollNotification)? onNotification;
  final EdgeInsetsGeometry? padding;
  final bool canPop;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double appBarHeight = AppHeader().preferredSize.height;
    double topMargin = height > 700 ? height - 700 : 0;
    if (topMargin > height * 0.18) topMargin = height * 0.18;
    final double sideMargin = width > 800 ? ((width / 2) - 400) + 0 : 0;

    return WillPopScope(
      onWillPop: () async {
        if (widget.canPop) Navigator.pop(context);
        return false;
      },
      child: GestureDetector(
        onTap: () => dismissKeyboard(context),
        child: Scaffold(
          appBar: AppHeader(),
          body: Container(
            height: height,
            width: width,
            decoration: _backgroundDecoration,
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
                              child: widget.body,
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
    );
  }

  BoxDecoration get _backgroundDecoration => const BoxDecoration(
        color: AppColors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/background/offline.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          // opacity: 0.7,
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
    double appBarHeight;
    double topMargin;
    double verticalPadding;

    height = MediaQuery.of(context).size.height;
    appBarHeight = AppHeader().preferredSize.height;
    topMargin = height > 700 ? height - 700 : 0;
    if (topMargin > height * 0.18) topMargin = height * 0.18;
    verticalPadding = widget.padding?.along(Axis.vertical) ?? 0;

    return BoxConstraints(
      minHeight: height - appBarHeight - topMargin - verticalPadding,
    );
  }
}
