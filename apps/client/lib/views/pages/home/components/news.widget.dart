import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/news_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/theme/theme.dart';
import 'package:forgottenland/views/widgets/src/buttons/card_button.widget.dart';
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

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _title(),
          _divider(),
          _body(),
        ],
      );

  Widget _title() => SelectableText(
        'Latest news',
        style: appTheme().textTheme.titleMedium,
      );

  Widget _divider() => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: const Divider(height: 1),
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

  Widget _listBuilder() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: newsCtrl.list.length < 3 ? newsCtrl.list.length : 3,
        itemBuilder: _itemBuilder,
      );

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
