import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/views/pages/home/components/expgain_overview.dart';
import 'package:forgottenland/views/pages/home/components/news.widget.dart';
import 'package:forgottenland/views/pages/home/components/onlinetime_overview.dart';
import 'package:forgottenland/views/pages/home/components/rookmaster_overview.dart';
import 'package:forgottenland/views/widgets/src/home_screen_grid.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:forgottenland/views/widgets/src/other/shimmer_loading.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeCtrl = Get.find<HomeController>();

  Future<void> _loadHomeData() async {
    if (homeCtrl.news.isEmpty) await homeCtrl.getNews();
    await homeCtrl.getOverview();
    homeCtrl.runTimer();
  }

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'home',
        canPop: false,
        postFrameCallback: _loadHomeData,
        onRefresh: _loadHomeData,
        maxWidth: 860,
        body: Shimmer(
          child: Column(
            children: <Widget>[
              _overview(),
              const SizedBox(height: 16, width: 16),
              Flex(
                direction: MediaQuery.of(context).size.width > 750 ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (MediaQuery.of(context).size.width > 750) Expanded(child: NewsWidget()),
                  if (MediaQuery.of(context).size.width > 750) const SizedBox(height: 16, width: 16),
                  if (MediaQuery.of(context).size.width <= 750) NewsWidget(),
                  if (MediaQuery.of(context).size.width <= 750) const SizedBox(height: 16, width: 16),
                  HomeScreenGrid(),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _overview() => Column(
        children: <Widget>[
          if (MediaQuery.of(context).size.width > 600) RookmasterOverview(),
          if (MediaQuery.of(context).size.width > 600) const SizedBox(height: 16, width: 16),
          Flex(
            direction: MediaQuery.of(context).size.width > 600 ? Axis.horizontal : Axis.vertical,
            children: <Widget>[
              if (MediaQuery.of(context).size.width <= 600) ExpgainOverview(),
              if (MediaQuery.of(context).size.width > 600) Expanded(child: ExpgainOverview()),
              const SizedBox(height: 16, width: 16),
              if (MediaQuery.of(context).size.width <= 600) OnlinetimeOverview(),
              if (MediaQuery.of(context).size.width > 600) Expanded(child: OnlinetimeOverview()),
            ],
          ),
        ],
      );
}
