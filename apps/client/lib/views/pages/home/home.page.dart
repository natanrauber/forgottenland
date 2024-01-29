import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/news_controller.dart';
import 'package:forgottenland/views/pages/home/components/news.widget.dart';
import 'package:forgottenland/views/widgets/src/home_screen_grid.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsController newsCtrl = Get.find<NewsController>();

  Future<void> _postFrameCallback() async {
    if (newsCtrl.list.isNotEmpty) return;
    newsCtrl.getNews();
  }

  @override
  Widget build(BuildContext context) => AppPage(
        canPop: false,
        postFrameCallback: _postFrameCallback,
        body: Column(
          children: <Widget>[
            const NewsWidget(),
            const SizedBox(height: 20),
            HomeScreenGrid(),
          ],
        ),
      );
}
