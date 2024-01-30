import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/modules/settings/controllers/settings_controller.dart';
import 'package:forgottenland/modules/settings/models/feature_model.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:get/get.dart';

class GridButtonModel {
  GridButtonModel({
    required this.enabled,
    required this.name,
    required this.icon,
    this.onTap,
    this.resizeBy = 0,
  });

  final bool enabled;
  final String name;
  final IconData icon;
  Function()? onTap;
  final double resizeBy;
}

class HomeScreenGrid extends StatelessWidget {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final SettingsController settingsCtrl = Get.find<SettingsController>();

  final List<GridButtonModel> _buttonList = <GridButtonModel>[];
  final int crossAxisCount = 4;
  final double crossAxisSpacing = 14;

  /// [configure button grid]
  ///
  /// defines which buttons will appear on the grid
  void _configureButtonGrid(BuildContext context) {
    _buttonList.clear();
    _buttonList.add(_highscores(context));
    _buttonList.add(_expgained(context));
    _buttonList.add(_rookmaster(context));
    _buttonList.add(_onlineCharacters(context));
    _buttonList.add(_characters(context));
    _buttonList.add(_bazaar(context));
    _buttonList.add(_liveStreams(context));
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
    final double buttonHeight = buttonWidth + 52;

    _configureButtonGrid(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: buttonWidth / (buttonHeight < 152 ? buttonHeight : 152),
      ),
      itemCount: _buttonList.length,
      itemBuilder: _gridItemBuilder,
    );
  }

  /// [grid item builder]
  Widget _gridItemBuilder(BuildContext context, int index) => MouseRegion(
        cursor: _buttonList[index].enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: _buttonList[index].enabled ? _buttonList[index].onTap : null,
          child: Column(
            children: <Widget>[
              //
              _buttonBody(context, index),

              SizedBox(height: _buttonList[index].name.contains('\n') ? 4 : 8),

              _buttonName(index),

              SizedBox(height: _buttonList[index].name.contains('\n') ? 16 : 12),
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
        size: 30 + _buttonList[index].resizeBy,
        color: _buttonList[index].enabled ? AppColors.primary : AppColors.bgDefault,
      ),
    );
  }

  /// [button name]
  Container _buttonName(int index) => Container(
        alignment: Alignment.topCenter,
        height: 32,
        child: SelectableText(
          _buttonList[index].name,
          textAlign: TextAlign.center,
          maxLines: _buttonList[index].name.contains('\n') ? 2 : 1,
          style: TextStyle(
            fontSize: 11,
            height: 15 / 11,
            fontWeight: FontWeight.w500,
            color: _buttonList[index].enabled ? AppColors.textPrimary : AppColors.bgPaper,
            overflow: TextOverflow.ellipsis,
          ),
          scrollPhysics: const NeverScrollableScrollPhysics(),
        ),
      );

  GridButtonModel _highscores(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Highscores',
        icon: CupertinoIcons.chart_bar_alt_fill,
        resizeBy: 2,
        onTap: _getToHighscoresPage,
      );

  Future<void> _getToHighscoresPage() async {
    final String c = highscoresCtrl.category.value;
    final String p = highscoresCtrl.timeframe.value;
    String route = '${Routes.highscores.name}/$c';
    if (c == 'Experience gained' || c == 'Online time') route = '$route/$p';

    return Get.toNamed(route.toLowerCase().replaceAll(' ', ''));
  }

  GridButtonModel _expgained(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Exp\ngained',
        icon: FontAwesomeIcons.chartLine,
        resizeBy: -4,
        onTap: () => Get.toNamed(
          '${Routes.highscores.name}/experiencegained/${highscoresCtrl.timeframe.value.toLowerCase()}',
        ),
      );

  GridButtonModel _rookmaster(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Rook\nMaster',
        icon: FontAwesomeIcons.trophy,
        resizeBy: -4,
        onTap: () => Get.toNamed('${Routes.highscores.name}/rookmaster'),
      );

  GridButtonModel _onlineCharacters(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Online')?.enabled ?? false,
        name: 'Who is\nonline',
        icon: CupertinoIcons.check_mark_circled_solid,
        onTap: () => Get.toNamed(Routes.online.name),
      );

  GridButtonModel _characters(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Characters')?.enabled ?? false,
        name: 'Characters',
        icon: CupertinoIcons.person_fill,
        onTap: () => Get.toNamed(Routes.character.name),
      );

  GridButtonModel _bazaar(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Bazaar')?.enabled ?? false,
        name: 'Char\nBazaar',
        icon: CupertinoIcons.money_dollar_circle_fill,
        onTap: () => Get.toNamed(Routes.bazaar.name),
      );

  GridButtonModel _liveStreams(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Streams')?.enabled ?? false,
        name: 'Live\nstreams',
        icon: CupertinoIcons.dot_radiowaves_left_right,
        onTap: () => Get.toNamed(Routes.livestreams.name),
      );

  GridButtonModel _about(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'About')?.enabled ?? false,
        name: 'About\nFL',
        icon: CupertinoIcons.shield_lefthalf_fill,
        onTap: () => Get.toNamed(Routes.guild.name),
      );
}
