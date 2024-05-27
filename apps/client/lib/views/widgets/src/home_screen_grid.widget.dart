import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/modules/settings/controllers/settings_controller.dart';
import 'package:forgottenland/modules/settings/models/feature_model.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/src/routes.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
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

class HomeScreenGrid extends StatefulWidget {
  @override
  State<HomeScreenGrid> createState() => _HomeScreenGridState();
}

class _HomeScreenGridState extends State<HomeScreenGrid> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();

  final SettingsController settingsCtrl = Get.find<SettingsController>();

  final List<GridButtonModel> _highscoresButtons = <GridButtonModel>[];
  final List<GridButtonModel> _libraryButtons = <GridButtonModel>[];
  final List<GridButtonModel> _otherButtons = <GridButtonModel>[];

  final int crossAxisCount = 4;
  final double crossAxisSpacing = 12;

  @override
  void initState() {
    super.initState();
    _highscoresButtons.clear();
    _highscoresButtons.add(_highscores(context));
    _highscoresButtons.add(_rookmaster(context));
    _highscoresButtons.add(_expgained(context));
    _highscoresButtons.add(_onlineTime(context));

    _otherButtons.add(_onlineCharacters(context));
    _otherButtons.add(_characters(context));
    _otherButtons.add(_bazaar(context));
    _otherButtons.add(_liveStreams(context));

    _libraryButtons.clear();
    _libraryButtons.add(_books(context));
    _libraryButtons.add(_npcs(context));
    _libraryButtons.add(_about(context));
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _grid('Highscores', _highscoresButtons),
          const SizedBox(height: 16),
          _grid('Other', _otherButtons),
          const SizedBox(height: 16),
          _grid('Library', _libraryButtons),
        ],
      );

  Widget _grid(String name, List<GridButtonModel> list) {
    double screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth > 436 ? 436 : screenWidth;
    final double spacing = (crossAxisCount - 1) * crossAxisSpacing;
    final double buttonWidth = (screenWidth - spacing - 32 - 24) / crossAxisCount;
    final double buttonHeight = buttonWidth + 36;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _title(name),
        const SizedBox(height: 3),
        Container(
          constraints: const BoxConstraints(maxWidth: 404),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgPaper,
            borderRadius: BorderRadius.circular(11),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: buttonWidth / (buttonHeight < 122 ? buttonHeight : 122),
            ),
            itemCount: list.length,
            itemBuilder: (_, int index) => _gridItemBuilder(list, index),
          ),
        ),
      ],
    );
  }

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(left: 3),
        child: SelectableText(text),
      );

  Widget _gridItemBuilder(List<GridButtonModel> list, int index) {
    final GridButtonModel item = list[index];

    return Column(
      children: <Widget>[
        _buttonBody(item),
        SizedBox(height: item.name.contains('\n') ? 4 : 8),
        _buttonName(item),
      ],
    );
  }

  Widget _buttonBody(GridButtonModel item) {
    double screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth > 436 ? 436 : screenWidth;
    final double spacing = (crossAxisCount - 1) * crossAxisSpacing;
    final double buttonSize = (screenWidth - spacing - 32 - 24) / crossAxisCount;

    return ClickableContainer(
      enabled: item.enabled,
      onTap: item.onTap,
      height: buttonSize,
      width: buttonSize,
      constraints: const BoxConstraints(maxHeight: 86, maxWidth: 86),
      color: AppColors.bgDefault.withOpacity(0.75),
      hoverColor: AppColors.bgHover,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        item.icon,
        size: 30 + item.resizeBy,
        color: item.enabled ? AppColors.primary : AppColors.textSecondary.withOpacity(0.25),
      ),
    );
  }

  Widget _buttonName(GridButtonModel item) => Text(
        item.name,
        textAlign: TextAlign.center,
        maxLines: item.name.contains('\n') ? 2 : 1,
        style: TextStyle(
          fontSize: 11,
          height: 15 / 11,
          fontWeight: FontWeight.w500,
          color: item.enabled ? AppColors.textPrimary : AppColors.textSecondary.withOpacity(0.25),
          overflow: TextOverflow.ellipsis,
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
        onTap: () {
          final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
          return Get.toNamed('${Routes.highscores.name}/experiencegained/$timeframe');
        },
      );

  GridButtonModel _rookmaster(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Rook\nMaster',
        icon: FontAwesomeIcons.trophy,
        resizeBy: -4,
        onTap: () => Get.toNamed('${Routes.highscores.name}/rookmaster'),
      );

  GridButtonModel _onlineTime(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Online\ntime',
        icon: FontAwesomeIcons.solidClock,
        resizeBy: -4,
        onTap: () {
          final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
          return Get.toNamed('${Routes.highscores.name}/onlinetime/$timeframe');
        },
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
        // enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Bazaar')?.enabled ?? false,
        enabled: false,
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

  GridButtonModel _books(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Books')?.enabled ?? false,
        name: 'Books',
        icon: FontAwesomeIcons.book,
        resizeBy: -2,
        onTap: () => Get.toNamed(Routes.books.name),
      );

  GridButtonModel _npcs(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'NPCs')?.enabled ?? false,
        name: 'NPCs\ntranscripts',
        icon: CupertinoIcons.doc_text_fill,
        onTap: () => Get.toNamed(Routes.npcs.name),
      );

  GridButtonModel _about(BuildContext context) => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'About')?.enabled ?? false,
        name: 'About\nFL',
        icon: CupertinoIcons.shield_lefthalf_fill,
        onTap: () => Get.toNamed(Routes.guild.name),
      );
}
