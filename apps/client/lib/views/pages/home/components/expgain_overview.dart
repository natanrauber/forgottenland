import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:forgottenland/views/widgets/src/other/blinking_circle.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
import 'package:forgottenland/views/widgets/src/other/shimmer_loading.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class ExpgainOverview extends StatefulWidget {
  @override
  State<ExpgainOverview> createState() => _ExpgainOverviewState();
}

class _ExpgainOverviewState extends State<ExpgainOverview> {
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
        child: SelectableText('Exp gained'),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.isLoading.value,
          child: ClickableContainer(
            onTap: homeCtrl.experiencegained.isEmpty
                ? homeCtrl.getOverview
                : () async {
                    final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
                    return Get.toNamed('${Routes.highscores.name}/experiencegained/$timeframe');
                  },
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            alignment: Alignment.centerLeft,
            color: AppColors.bgPaper,
            hoverColor: AppColors.bgHover,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Builder(
              builder: (_) {
                if (homeCtrl.isLoading.value) return _loading();
                if (homeCtrl.experiencegained.isEmpty) return _reloadButton();
                if (homeCtrl.experiencegained.isNotEmpty) return _listBuilder();
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
          child: Icon(
            Icons.refresh,
            size: 40,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
        ),
      );

  Widget _loading() => Center(
        child: Container(
          height: 125,
          width: 125,
          padding: const EdgeInsets.all(47.5),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
        ),
      );

  Widget _listBuilder() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (homeCtrl.experiencegained.isNotEmpty) _item(homeCtrl.experiencegained[0]),
          if (homeCtrl.experiencegained.length >= 2) _item(homeCtrl.experiencegained[1]),
          if (homeCtrl.experiencegained.length >= 3) _item(homeCtrl.experiencegained[2]),
          if (homeCtrl.experiencegained.length >= 4) _item(homeCtrl.experiencegained[3]),
          if (homeCtrl.experiencegained.length >= 5) _item(homeCtrl.experiencegained[4]),
        ],
      );

  Widget _item(HighscoresEntry item) => Container(
        height: 19,
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
          height: 19 / 12,
          color: item.isOnline ? Colors.transparent : AppColors.textSecondary.withOpacity(0.5),
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
            height: 19 / 12,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

  Widget _itemValue(HighscoresEntry item) => Text(
        '+${item.stringValue}',
        style: const TextStyle(
          fontSize: 12,
          height: 19 / 12,
          color: Colors.green,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
