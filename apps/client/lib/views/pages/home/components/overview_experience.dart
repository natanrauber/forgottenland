import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:forgottenland/views/widgets/src/other/better_text.dart';
import 'package:forgottenland/views/widgets/src/other/blinking_circle.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
import 'package:forgottenland/views/widgets/src/other/shimmer_loading.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class OverviewExperience extends StatefulWidget {
  @override
  State<OverviewExperience> createState() => _OverviewExperienceState();
}

class _OverviewExperienceState extends State<OverviewExperience> {
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

  Widget _title() => Container(
        height: 22,
        padding: const EdgeInsets.only(left: 3),
        child: const SelectableText(
          'Top level',
          style: TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.overviewExperience.isEmpty && homeCtrl.isLoading.value,
          child: ClickableContainer(
            enabled: _isEnabled,
            height: 143,
            onTap: homeCtrl.overviewExperience.isEmpty
                ? homeCtrl.getOverview
                : () => Get.toNamed('${Routes.highscores.name}/experience'),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            color: AppColors.bgPaper,
            hoverColor: AppColors.bgHover,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Builder(
              builder: (_) {
                if (homeCtrl.overviewExperience.isEmpty && homeCtrl.isLoading.value) return _loading();
                if (homeCtrl.overviewExperience.isEmpty) return _reloadButton();
                if (homeCtrl.overviewExperience.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  bool get _isEnabled {
    if (homeCtrl.isLoading.value && homeCtrl.overviewExperience.isEmpty) return false;
    return true;
  }

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
          padding: const EdgeInsets.all(50),
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
          if (homeCtrl.overviewExperience.isNotEmpty) _item(homeCtrl.overviewExperience[0]),
          if (homeCtrl.overviewExperience.length >= 2) _item(homeCtrl.overviewExperience[1]),
          if (homeCtrl.overviewExperience.length >= 3) _item(homeCtrl.overviewExperience[2]),
          if (homeCtrl.overviewExperience.length >= 4) _item(homeCtrl.overviewExperience[3]),
          if (homeCtrl.overviewExperience.length >= 5) _item(homeCtrl.overviewExperience[4]),
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
                if (item.isOnline && !homeCtrl.isLoading.value) _onlineIndicator(),
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
          color: item.isOnline && !homeCtrl.isLoading.value
              ? Colors.transparent
              : AppColors.textSecondary.withOpacity(0.5),
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

  Widget _itemValue(HighscoresEntry item) => BetterText(
        _itemValueText(item),
        selectable: false,
        style: TextStyle(
          fontSize: 12,
          height: 19 / 12,
          color: AppColors.textSecondary.withOpacity(0.5),
          overflow: TextOverflow.ellipsis,
        ),
      );

  String _itemValueText(HighscoresEntry item) {
    if (MediaQuery.of(context).size.width < 1280) return '<blue>${item.level ?? ''}<blue>';
    return '${item.world ?? ''} <blue>${item.level ?? ''}<blue>';
  }
}
