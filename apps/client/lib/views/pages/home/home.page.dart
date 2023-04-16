import 'package:flutter/material.dart';
import 'package:forgottenland/views/pages/home/components/news.widget.dart';
import 'package:forgottenland/views/widgets/src/home_screen_grid.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => AppPage(
        canPop: false,
        body: Column(
          children: <Widget>[
            //
            const NewsWidget(),

            const SizedBox(height: 20),

            HomeScreenGrid(),
          ],
        ),
      );
}
