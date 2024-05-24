import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
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
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.bgPaper,
              borderRadius: BorderRadius.circular(11),
            ),
            child: _body(),
          ),
        ],
      );

  Widget _title() => const Padding(
        padding: EdgeInsets.only(left: 3),
        child: SelectableText('Exp gained'),
      );

  Widget _body() => Obx(
        () {
          if (homeCtrl.isLoading.value) return _loading();
          if (homeCtrl.experiencegained.isEmpty) return _reloadButton();
          if (homeCtrl.experiencegained.isNotEmpty) return _listBuilder();
          return Container();
        },
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

  Widget _listBuilder() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
            return Get.toNamed('${Routes.highscores.name}/experiencegained/$timeframe');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (homeCtrl.experiencegained.isNotEmpty) _item(homeCtrl.experiencegained[0]),
              if (homeCtrl.experiencegained.length >= 2) _item(homeCtrl.experiencegained[1]),
              if (homeCtrl.experiencegained.length >= 3) _item(homeCtrl.experiencegained[2]),
              if (homeCtrl.experiencegained.length >= 4) _item(homeCtrl.experiencegained[3]),
              if (homeCtrl.experiencegained.length >= 5) _item(homeCtrl.experiencegained[4]),
            ],
          ),
        ),
      );

  Widget _item(HighscoresEntry item) => Container(
        margin: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: <Widget>[
            //
            Expanded(
              child: Text(
                _itemName(item),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            Text(
              _itemValue(item),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.green,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  String _itemName(HighscoresEntry item) {
    if (MediaQuery.of(context).size.width <= 750) return item.name ?? '';
    return '${item.rank}. ${item.name}';
  }

  String _itemValue(HighscoresEntry item) {
    if (MediaQuery.of(context).size.width <= 750) return ' ${item.shortValue ?? ''}';
    return ' +${item.stringValue}';
  }
}
