import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:forgottenland/views/widgets/src/other/blinking_circle.dart';
import 'package:forgottenland/views/widgets/src/other/shimmer_loading.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class OnlinetimeOverview extends StatefulWidget {
  @override
  State<OnlinetimeOverview> createState() => _OnlinetimeOverviewState();
}

class _OnlinetimeOverviewState extends State<OnlinetimeOverview> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
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
        child: SelectableText('Online time'),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.isLoading.value,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.bgPaper,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Builder(
              builder: (_) {
                if (homeCtrl.isLoading.value) return _loading();
                if (homeCtrl.onlinetime.isEmpty) return _reloadButton();
                if (homeCtrl.onlinetime.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  Widget _reloadButton() => Center(
        child: GestureDetector(
          onTap: homeCtrl.getOverview,
          child: Container(
            height: 110,
            width: 110,
            padding: const EdgeInsets.all(30),
            child: const Icon(
              Icons.refresh,
              size: 50,
              color: AppColors.bgDefault,
            ),
          ),
        ),
      );

  Widget _loading() => Center(
        child: Container(
          height: 110,
          width: 110,
          padding: const EdgeInsets.all(30),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );

  Widget _listBuilder() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
            return Get.toNamed('${Routes.highscores.name}/onlinetime/$timeframe');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (homeCtrl.onlinetime.isNotEmpty) _item(homeCtrl.onlinetime[0]),
              if (homeCtrl.onlinetime.length >= 2) _item(homeCtrl.onlinetime[1]),
              if (homeCtrl.onlinetime.length >= 3) _item(homeCtrl.onlinetime[2]),
              if (homeCtrl.onlinetime.length >= 4) _item(homeCtrl.onlinetime[3]),
              if (homeCtrl.onlinetime.length >= 5) _item(homeCtrl.onlinetime[4]),
            ],
          ),
        ),
      );

  Widget _item(HighscoresEntry item) => Container(
        margin: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                _itemRank(item),
                if (item.isOnline) _onlineIndicator(),
              ],
            ),
            const SizedBox(width: 2),
            _itemName(item),
            const SizedBox(width: 2),
            _itemValue(item),
          ],
        ),
      );

  Widget _itemRank(HighscoresEntry item) => Text(
        '${item.rank}.',
        style: TextStyle(
          fontSize: 12,
          color: item.isOnline ? Colors.transparent : AppColors.textSecondary.withOpacity(0.25),
        ),
      );

  Widget _onlineIndicator() => const Padding(
        padding: EdgeInsets.only(bottom: 1),
        child: BlinkingCircle(),
      );

  Widget _itemName(HighscoresEntry item) => Expanded(
        child: Text(
          item.name ?? '',
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

  Widget _itemValue(HighscoresEntry item) => Text(
        item.onlineTime ?? '',
        style: TextStyle(
          fontSize: 12,
          color: _itemValueColor(item),
          overflow: TextOverflow.ellipsis,
        ),
      );

  Color _itemValueColor(HighscoresEntry item) {
    if ((int.tryParse(item.onlineTime?.substring(0, 2) ?? '') ?? 0) >= 8) return Colors.red;
    return AppColors.textPrimary;
  }
}
