import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/views/pages/home/components/expgain_overview.dart';
import 'package:forgottenland/views/pages/home/components/news.widget.dart';
import 'package:forgottenland/views/pages/home/components/onlinetime_overview.dart';
import 'package:forgottenland/views/pages/home/components/rookmaster_overview.dart';
import 'package:forgottenland/views/widgets/src/home_screen_grid.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController newsCtrl = Get.find<HomeController>();

  Future<void> _loadHomeData() async {
    if (newsCtrl.news.isEmpty) await newsCtrl.getNews();
    newsCtrl.getOverview();
  }

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'home',
        canPop: false,
        postFrameCallback: _loadHomeData,
        onRefresh: _loadHomeData,
        maxWidth: 860,
        body: Column(
          children: <Widget>[
            RookmasterOverview(),
            const SizedBox(height: 16, width: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: ExpgainOverview()),
                const SizedBox(height: 16, width: 16),
                Expanded(child: OnlinetimeOverview()),
              ],
            ),
            const SizedBox(height: 16, width: 16),
            Flex(
              direction: MediaQuery.of(context).size.width > 750 ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (MediaQuery.of(context).size.width > 750) Expanded(child: NewsWidget()),
                if (MediaQuery.of(context).size.width > 750) const SizedBox(height: 16, width: 16),
                HomeScreenGrid(),
                if (MediaQuery.of(context).size.width <= 750) const SizedBox(height: 16, width: 16),
                if (MediaQuery.of(context).size.width <= 750) NewsWidget(),
              ],
            ),
          ],
        ),
      );
}
