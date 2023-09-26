import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/news_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/theme/theme.dart';
import 'package:forgottenland/views/widgets/src/buttons/card_button.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_header.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:utils/utils.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final NewsController newsCtrl = Get.find<NewsController>();

  late double height;

  @override
  void initState() {
    super.initState();
    if (newsCtrl.list.isNotEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => newsCtrl.getNews());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight;
    double appBarHeight;
    double topMargin;
    double buttonsHeight;
    double paddings;

    screenHeight = MediaQuery.of(context).size.height;
    appBarHeight = AppHeader().preferredSize.height;
    topMargin = screenHeight > 700 ? screenHeight - 700 : 0;
    if (topMargin > screenHeight * 0.18) topMargin = screenHeight * 0.18;
    buttonsHeight = 152;
    paddings = 20 + 20;
    height = screenHeight - appBarHeight - topMargin - buttonsHeight - paddings;

    return Container(
      height: height,
      decoration: _decoration,
      child: Column(
        children: <Widget>[
          //
          const SizedBox(height: 20),

          _title(),

          const SizedBox(height: 10),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(height: 1),
          ),

          _body(),
        ],
      ),
    );
  }

  BoxDecoration get _decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppColors.bgPaper,
        ),
      );

  Widget _title() => SelectableText(
        'Latest news',
        style: appTheme().textTheme.titleMedium,
      );

  Widget _body() => Obx(
        () {
          if (newsCtrl.isLoading.value) return _loading();
          if (newsCtrl.list.isEmpty) return _reloadButton();
          if (newsCtrl.list.isNotEmpty) return _listBuilder();
          return Container();
        },
      );

  Widget _loading() => Container(
        height: 110,
        width: 110,
        padding: const EdgeInsets.all(30),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _reloadButton() => GestureDetector(
        onTap: newsCtrl.getNews,
        child: Container(
          height: 110,
          width: 110,
          padding: const EdgeInsets.all(30),
          child: const Icon(
            Icons.refresh,
            size: 50,
            color: AppColors.bgPaper,
          ),
        ),
      );

  Widget _listBuilder() {
    final int maxCount = (height - 75) ~/ 120;

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: newsCtrl.list.length < maxCount ? newsCtrl.list.length : maxCount,
        itemBuilder: _itemBuilder,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final News item = newsCtrl.list[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 15),
      child: CardButton(
        onTap: () => _openSelectedNews(index),
        title: item.news,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            const SizedBox(height: 5),

            Text(
              'Date: ${item.date ?? ''}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Category: ${item.category?.capitalizeString() ?? ''}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSelectedNews(int index) async {
    final String? url = newsCtrl.list[index].url;
    if (url == null) return;
    await launchUrlString(url);
  }
}
