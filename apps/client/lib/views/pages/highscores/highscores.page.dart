import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/pages/highscores/components/filter_bar.widget.dart';
import 'package:forgottenland/views/pages/highscores/components/highscores_item.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class HighscoresPage extends StatefulWidget {
  const HighscoresPage({this.category, this.timeframe});

  final String? category;
  final String? timeframe;

  @override
  State<HighscoresPage> createState() => _HighscoresPageState();
}

class _HighscoresPageState extends State<HighscoresPage> {
  final CharacterController characterCtrl = Get.find<CharacterController>();
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final UserController userCtrl = Get.find<UserController>();

  Future<void> _postFrameCallback() async {
    final String c = widget.category ?? LIST.category.first;
    final String p = widget.timeframe ?? LIST.timeframe.first;
    if (_alreadyLoaded(c, p)) return;

    highscoresCtrl.category.value = c;
    highscoresCtrl.timeframe.value = p;
    _loadHighscores();
  }

  bool _alreadyLoaded(String c, String p) {
    if (highscoresCtrl.category.value != c) return false;
    if (highscoresCtrl.timeframe.value != p) return false;
    if (highscoresCtrl.rawList.isEmpty) return false;
    return true;
  }

  Future<void> _loadHighscores({bool newPage = false}) async {
    if (highscoresCtrl.supporters.isEmpty) await highscoresCtrl.getSupporters();
    if (highscoresCtrl.hidden.isEmpty) await highscoresCtrl.getHidden();
    await highscoresCtrl.loadHighscores(newPage: newPage);
  }

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'highscores',
        postFrameCallback: _postFrameCallback,
        onRefresh: _loadHighscores,
        onNotification: _onScrollNotification,
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: Column(
          children: <Widget>[
            //
            HighscoresFilterBar(),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _body(),
            ),
          ],
        ),
      );

  bool _onScrollNotification(ScrollNotification scrollInfo) {
    double maxScroll;
    double currentScroll;

    maxScroll = scrollInfo.metrics.maxScrollExtent;
    currentScroll = scrollInfo.metrics.pixels;

    if (scrollInfo.metrics.axis == Axis.horizontal) return true;
    if (currentScroll != maxScroll) return true;
    if (highscoresCtrl.isLoading.value) return true;
    if (userCtrl.isLoading.value) return true;
    if (highscoresCtrl.pageCtrl.value == 20) return true;
    if (highscoresCtrl.loadedAll.value) return true;

    _loadHighscores(newPage: true);
    return true;
  }

  Widget _body() => Obx(
        () {
          if (userCtrl.isLoading.value) return _loading();
          if (highscoresCtrl.filteredList.isNotEmpty) return _listBuilder();
          if (!highscoresCtrl.isLoading.value) return _reloadButton();
          return Container();
        },
      );

  Widget _listBuilder() {
    final bool hideData =
        LIST.premiumCategories.contains(highscoresCtrl.category.value) && userCtrl.isLoggedIn.value != true;
    final int listLength = highscoresCtrl.filteredList.length;
    int itemCount = hideData ? 3 : listLength;
    if (itemCount > listLength) itemCount = listLength;

    return Column(
      children: <Widget>[
        //
        if (hideData) _loginText(),

        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount + 1,
          itemBuilder: (BuildContext context, int index) => _itemBuilder(context, index, itemCount),
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index, int itemCount) {
    if (index == itemCount) {
      if (highscoresCtrl.loadedAll.value) return Container();
      if (highscoresCtrl.isLoading.value) return _loading();
      if (userCtrl.isLoading.value) return _loading();
      if (highscoresCtrl.rawList.length < 1000) return _reloadButton();
      return Container();
    }

    final HighscoresEntry item = highscoresCtrl.filteredList[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: HighscoresItemCard(
        index: index,
        item: item,
        disableOnTap: highscoresCtrl.category.value == 'Rook Master',
        characterCtrl: characterCtrl,
        highscoresCtrl: highscoresCtrl,
        userCtrl: userCtrl,
      ),
    );
  }

  Widget _loading() => Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(37.5),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
        ),
      );

  Widget _reloadButton() {
    final bool hideData =
        LIST.premiumCategories.contains(highscoresCtrl.category.value) && userCtrl.isLoggedIn.value != true;

    if (highscoresCtrl.pageCtrl.value >= 20) return Container(height: 100);
    if (hideData && highscoresCtrl.filteredList.length > 3) return Container(height: 100);
    if (highscoresCtrl.loadedAll.value) return Container(height: 100);

    return GestureDetector(
      onTap: () => _loadHighscores(newPage: true),
      child: Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(30),
        child: const Icon(
          Icons.refresh,
          size: 40,
          color: AppColors.bgPaper,
        ),
      ),
    );
  }

  Widget _loginText() => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, bottom: 30),
        child: SelectableText.rich(
          TextSpan(
            style: const TextStyle(
              color: AppColors.textPrimary,
            ),
            children: <InlineSpan>[
              //
              TextSpan(
                text: 'Log in',
                style: const TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.blue,
                ),
                recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.login.name),
              ),

              const TextSpan(
                text: ' to view the full content.',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      );
}
