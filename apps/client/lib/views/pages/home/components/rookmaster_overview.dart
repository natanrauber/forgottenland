import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/home_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class RookmasterOverview extends StatefulWidget {
  @override
  State<RookmasterOverview> createState() => _RookmasterOverviewState();
}

class _RookmasterOverviewState extends State<RookmasterOverview> {
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
        child: SelectableText('Rookmaster'),
      );

  Widget _body() => Obx(
        () {
          if (homeCtrl.isLoading.value) return _loading();
          if (homeCtrl.rookmaster.isEmpty) return _reloadButton();
          if (homeCtrl.rookmaster.isNotEmpty) return _listBuilder();
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
          onTap: () => Get.toNamed('${Routes.highscores.name}/rookmaster'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (homeCtrl.rookmaster.isNotEmpty) _item(homeCtrl.rookmaster[0]),
              if (homeCtrl.rookmaster.length >= 2) _item(homeCtrl.rookmaster[1]),
              if (homeCtrl.rookmaster.length >= 3) _item(homeCtrl.rookmaster[2]),
              if (homeCtrl.rookmaster.length >= 4) _item(homeCtrl.rookmaster[3]),
              if (homeCtrl.rookmaster.length >= 5) _item(homeCtrl.rookmaster[4]),
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
              ' ${item.stringValue ?? ''}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blue,
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
}
