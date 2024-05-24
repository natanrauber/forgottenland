import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/views/pages/home/components/expgain_overview.dart';
import 'package:forgottenland/views/pages/home/components/news.widget.dart';
import 'package:forgottenland/views/pages/home/components/onlinetime_overview.dart';
import 'package:forgottenland/views/widgets/src/home_screen_grid.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController newsCtrl = Get.find<HomeController>();

  Future<void> _postFrameCallback() async {
    if (newsCtrl.news.isNotEmpty) return;
    newsCtrl.getNews();
    newsCtrl.getOverview();
  }

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'home',
        canPop: false,
        postFrameCallback: _postFrameCallback,
        maxWidth: 860,
        body: Column(
          children: <Widget>[
            Flex(
              direction: MediaQuery.of(context).size.width > 750 ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (MediaQuery.of(context).size.width <= 750) ExpgainOverview(),
                if (MediaQuery.of(context).size.width > 750) Expanded(child: ExpgainOverview()),
                const SizedBox(height: 20, width: 20),
                if (MediaQuery.of(context).size.width <= 750) OnlinetimeOverview(),
                if (MediaQuery.of(context).size.width > 750) Expanded(child: OnlinetimeOverview()),
              ],
            ),
            const SizedBox(height: 20, width: 20),
            Flex(
              direction: MediaQuery.of(context).size.width > 750 ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HomeScreenGrid(),
                const SizedBox(height: 20, width: 20),
                if (MediaQuery.of(context).size.width <= 750) NewsWidget(),
                if (MediaQuery.of(context).size.width > 750) Expanded(child: NewsWidget()),
              ],
            ),
          ],
        ),
      );
}
