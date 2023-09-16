import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:get/get.dart';

class GridButtonModel {
  GridButtonModel({
    required this.name,
    required this.icon,
    this.onTap,
  });

  final String name;
  final IconData icon;
  Function()? onTap;
}

class HomeScreenGrid extends StatelessWidget {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();

  final List<GridButtonModel> _buttonList = <GridButtonModel>[];
  final int crossAxisCount = 4;
  final double crossAxisSpacing = 14;

  /// [configure button grid]
  ///
  /// defines which buttons will appear on the grid
  void _configureButtonGrid(BuildContext context) {
    _buttonList.clear();
    _buttonList.add(_highscores(context));
    _buttonList.add(_onlineCharacters(context));
    _buttonList.add(_characters(context));
    _buttonList.add(_about(context));
  }

  /// [grid] builder
  ///
  /// grid view of buttons
  @override
  GridView build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth > 800 ? 800 : screenWidth;
    final double spacing = (crossAxisCount - 1) * crossAxisSpacing;
    final double buttonWidth = (screenWidth - spacing - 40) / crossAxisCount;
    final double buttonHeight = buttonWidth + 32;

    _configureButtonGrid(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: buttonWidth / (buttonHeight < 132 ? buttonHeight : 132),
      ),
      itemCount: _buttonList.length,
      itemBuilder: _gridItemBuilder,
    );
  }

  /// [grid item builder]
  Widget _gridItemBuilder(BuildContext context, int index) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _buttonList[index].onTap,
          child: Column(
            children: <Widget>[
              //
              _buttonBody(context, index),

              const SizedBox(height: 8),

              _buttonName(index),
            ],
          ),
        ),
      );

  /// [button body]
  Container _buttonBody(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth > 800 ? 800 : screenWidth;
    final double spacing = (crossAxisCount - 1) * crossAxisSpacing;
    final double buttonSize = (screenWidth - spacing - 40) / crossAxisCount;

    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      height: buttonSize,
      width: buttonSize,
      decoration: BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        _buttonList[index].icon,
        size: 30,
      ),
    );
  }

  /// [button name]
  Container _buttonName(int index) => Container(
        alignment: Alignment.center,
        height: 24,
        child: SelectableText(
          _buttonList[index].name,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

  GridButtonModel _highscores(BuildContext context) => GridButtonModel(
        name: 'Highscores',
        icon: CupertinoIcons.chart_bar_alt_fill,
        onTap: _getToHighscoresPage,
      );

  Future<void> _getToHighscoresPage() async {
    final String c = highscoresCtrl.category.value;
    final String p = highscoresCtrl.timeframe.value;
    String route = '${Routes.highscores.name}/$c';
    if (c == 'Experience gained' || c == 'Online time') route = '$route/$p';

    return Get.toNamed(route.toLowerCase().replaceAll(' ', ''));
  }

  GridButtonModel _onlineCharacters(BuildContext context) => GridButtonModel(
        name: 'Online',
        icon: CupertinoIcons.check_mark_circled_solid,
        onTap: () => Get.toNamed(Routes.online.name),
      );

  GridButtonModel _characters(BuildContext context) => GridButtonModel(
        name: 'Characters',
        icon: CupertinoIcons.person_fill,
        onTap: () => Get.toNamed(Routes.character.name),
      );

  GridButtonModel _about(BuildContext context) => GridButtonModel(
        name: 'About',
        icon: CupertinoIcons.info_circle_fill,
        onTap: () => Get.toNamed(Routes.guild.name),
      );
}
