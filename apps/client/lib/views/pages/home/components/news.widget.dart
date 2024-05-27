import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
import 'package:forgottenland/views/widgets/src/other/shimmer_loading.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:utils/utils.dart';

class NewsWidget extends StatefulWidget {
  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          const SizedBox(height: 3),
          _body(),
        ],
      );

  Widget _title() => const Padding(
        padding: EdgeInsets.only(left: 3),
        child: SelectableText('Latest news'),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.isLoading.value,
          child: ClickableContainer(
            enabled: homeCtrl.news.isEmpty,
            onTap: homeCtrl.getNews,
            padding: const EdgeInsets.all(12),
            color: AppColors.bgPaper,
            hoverColor: AppColors.bgHover,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
            ),
            child: Builder(
              builder: (_) {
                if (homeCtrl.news.isEmpty) return _reloadButton();
                if (homeCtrl.news.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  Widget _reloadButton() => Center(
        child: Container(
          height: 125,
          width: 125,
          padding: const EdgeInsets.all(42.5),
          child: homeCtrl.isLoading.value
              ? _loading()
              : Icon(
                  Icons.refresh,
                  size: 40,
                  color: AppColors.textSecondary.withOpacity(0.25),
                ),
        ),
      );

  Widget _loading() => const Center(
        child: CircularProgressIndicator(
          color: AppColors.textSecondary,
        ),
      );

  Widget _listBuilder() => Flex(
        direction: MediaQuery.of(context).size.width > 750 ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (homeCtrl.news.isNotEmpty) _item(homeCtrl.news[0]),
          if (homeCtrl.news.length >= 2) const SizedBox(height: 12, width: 12),
          if (homeCtrl.news.length >= 2) _item(homeCtrl.news[1]),

          //
          if (homeCtrl.news.length >= 3 && MediaQuery.of(context).size.width > 700)
            const SizedBox(height: 12, width: 12),
          if (homeCtrl.news.length >= 3 && MediaQuery.of(context).size.width > 700) _item(homeCtrl.news[2]),

          //
          if (homeCtrl.news.length >= 4 && MediaQuery.of(context).size.width > 750)
            const SizedBox(height: 12, width: 12),
          if (homeCtrl.news.length >= 4 && MediaQuery.of(context).size.width > 750) _item(homeCtrl.news[3]),

          //
          if (homeCtrl.news.length >= 5 && MediaQuery.of(context).size.width > 750)
            const SizedBox(height: 12, width: 12),
          if (homeCtrl.news.length >= 5 && MediaQuery.of(context).size.width > 750) _item(homeCtrl.news[4]),
        ],
      );

  Widget _item(News item) {
    if (MediaQuery.of(context).size.width > 750) return _itemBody(item);
    return Expanded(child: _itemBody(item));
  }

  Widget _itemBody(News item) => ClickableContainer(
        onTap: () => _openSelectedNews(item),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.centerLeft,
        color: AppColors.bgDefault.withOpacity(0.75),
        hoverColor: AppColors.bgHover,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            Text(
              item.news ?? '',
              maxLines: 2,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              MediaQuery.of(context).size.width > 600 ? 'Date: ${item.date ?? ''}' : item.date ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              MediaQuery.of(context).size.width > 600
                  ? 'Category: ${item.category?.capitalizeString() ?? ''}'
                  : item.category?.capitalizeString() ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Future<void> _openSelectedNews(News item) async {
    final String? url = item.url;
    if (url == null) return;
    await launchUrlString(url);
  }
}
