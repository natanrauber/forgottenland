import 'package:flutter/cupertino.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/better_text.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class HighscoresItemCard extends StatefulWidget {
  const HighscoresItemCard({
    required this.index,
    required this.item,
    this.disableOnTap = false,
    required this.characterCtrl,
    required this.highscoresCtrl,
    required this.userCtrl,
  });

  final int index;
  final HighscoresEntry item;
  final bool disableOnTap;

  final CharacterController characterCtrl;
  final HighscoresController highscoresCtrl;
  final UserController userCtrl;

  @override
  State<HighscoresItemCard> createState() => _HighscoresItemCardState();
}

class _HighscoresItemCardState extends State<HighscoresItemCard> {
  bool expand = false;

  @override
  Widget build(BuildContext context) => ClickableContainer(
        enabled: !widget.disableOnTap,
        onTap: widget.disableOnTap ? null : _onTap,
        padding: const EdgeInsets.all(16),
        color: AppColors.bgPaper,
        hoverColor: AppColors.bgHover,
        decoration: _decoration(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //
                  SizedBox(
                    height: 20,
                    child: Row(
                      children: <Widget>[
                        //
                        _rank(),

                        const SizedBox(width: 4),

                        Expanded(child: _name()),
                      ],
                    ),
                  ),

                  if (widget.highscoresCtrl.world.value.name == 'All') _info('World: ${widget.item.world?.name ?? ''}'),

                  if (widget.highscoresCtrl.category.value != 'Rook Master') _info('Level: ${widget.item.level ?? ''}'),

                  if (widget.item.onlineTime != null) _info('Online time: ${widget.item.onlineTime ?? ''}'),

                  if (widget.item.value != null) _info('$_rankName: $_value'),

                  if (widget.highscoresCtrl.category.value == 'Rook Master') _skillsPosition(widget.item),

                  // if (widget.item.supporterTitle != null)
                  //   _info('\n<primary>${widget.item.supporterTitle ?? ''}<primary>'),
                ],
              ),
            ),

            const SizedBox(width: 4),

            _infoIcons(context),
          ],
        ),
      );

  void _onTap() {
    dismissKeyboard(context);
    _loadCharacter(context);
  }

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: widget.item.supporterTitle == null ? null : Border.all(color: AppColors.primary),
      );

  Widget _rank() => SizedBox(
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //
            _rankImage(),

            Text(
              _rankValue ?? '',
              style: const TextStyle(
                fontSize: 11,
                height: 13 / 11,
                fontWeight: FontWeight.w600,
                color: AppColors.bgDefault,
              ),
            ),
          ],
        ),
      );

  Widget _rankImage() {
    final int length = (_rankValue ?? ' ').length;
    final AssetImage? image = widget.highscoresCtrl.images['assets/icons/rank/rank$length.png'];
    if (image == null) return Container();
    return Image(image: image);
  }

  String? get _rankValue {
    if (_showGlobalRank) return (widget.index + 1).toString();
    if (widget.highscoresCtrl.category.value == 'Experience gained') return (widget.index + 1).toString();
    if (widget.highscoresCtrl.category.value == 'Online time') return (widget.index + 1).toString();
    return widget.item.rank?.toString();
  }

  Widget _name() => Text(
        widget.item.name ?? '',
        style: const TextStyle(
          height: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _info(String text) => Container(
        margin: const EdgeInsets.only(top: 4),
        child: BetterText(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      );

  String get _rankName {
    final String name = widget.highscoresCtrl.category.value;
    if (name == 'Rook Master') return 'Total points';
    return name;
  }

  String get _value {
    final bool hideData = LIST.premiumCategories.contains(widget.highscoresCtrl.category.value) &&
        widget.userCtrl.isLoggedIn.value != true;

    if (hideData) return '<primary>???<primary>';
    if (_rankName == 'Experience gained') return '<green>+${widget.item.stringValue}<green>';
    return widget.item.stringValue ?? '---';
  }

  Widget _skillsPosition(HighscoresEntry entry) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _info(''),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => setState(() => expand = !expand),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(
                      expand ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expand)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info('Level:'),
                    _info('Fist:'),
                    _info('Axe:'),
                    _info('Club:'),
                    _info('Sword:'),
                    _info('Distance:'),
                    _info('Shielding:'),
                    _info('Fishing:'),
                  ],
                ),
                const SizedBox(width: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info('${entry.level ?? 'n/a'}'),
                    _info('${entry.expanded?.fist.value ?? 'n/a'}'),
                    _info('${entry.expanded?.axe.value ?? 'n/a'}'),
                    _info('${entry.expanded?.club.value ?? 'n/a'}'),
                    _info('${entry.expanded?.sword.value ?? 'n/a'}'),
                    _info('${entry.expanded?.distance.value ?? 'n/a'}'),
                    _info('${entry.expanded?.shielding.value ?? 'n/a'}'),
                    _info('${entry.expanded?.fishing.value ?? 'n/a'}'),
                  ],
                ),
                const SizedBox(width: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info(entry.expanded?.experience.value == null ? '' : '#${entry.expanded?.experience.position}'),
                    _info(entry.expanded?.fist.value == null ? '' : '#${entry.expanded?.fist.position}'),
                    _info(entry.expanded?.axe.value == null ? '' : '#${entry.expanded?.axe.position}'),
                    _info(entry.expanded?.club.value == null ? '' : '#${entry.expanded?.club.position}'),
                    _info(entry.expanded?.sword.value == null ? '' : '#${entry.expanded?.sword.position}'),
                    _info(entry.expanded?.distance.value == null ? '' : '#${entry.expanded?.distance.position}'),
                    _info(entry.expanded?.shielding.value == null ? '' : '#${entry.expanded?.shielding.position}'),
                    _info(entry.expanded?.fishing.value == null ? '' : '#${entry.expanded?.fishing.position}'),
                  ],
                ),
                const SizedBox(width: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info(entry.expanded?.experience.value == null ? '' : '+${entry.expanded?.experience.points}'),
                    _info(entry.expanded?.fist.value == null ? '' : '+${entry.expanded?.fist.points}'),
                    _info(entry.expanded?.axe.value == null ? '' : '+${entry.expanded?.axe.points}'),
                    _info(entry.expanded?.club.value == null ? '' : '+${entry.expanded?.club.points}'),
                    _info(entry.expanded?.sword.value == null ? '' : '+${entry.expanded?.sword.points}'),
                    _info(entry.expanded?.distance.value == null ? '' : '+${entry.expanded?.distance.points}'),
                    _info(entry.expanded?.shielding.value == null ? '' : '+${entry.expanded?.shielding.points}'),
                    _info(entry.expanded?.fishing.value == null ? '' : '+${entry.expanded?.fishing.points}'),
                  ],
                ),
              ],
            ),
        ],
      );

  Widget _infoIcons(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //
          if (_showGlobalRank) _globalRank(),

          _battleyeTypeIcon(),

          _pvpType(),
        ],
      );

  bool get _showGlobalRank {
    if (widget.highscoresCtrl.rawList.length != widget.highscoresCtrl.filteredList.length) return true;
    return false;
  }

  Widget _infoIcon({required Widget child}) => Container(
        height: 20,
        margin: const EdgeInsets.only(bottom: 4),
        child: child,
      );

  Widget _battleyeTypeIcon() {
    final String? type = widget.item.world?.battleyeType?.toLowerCase();
    final AssetImage? image = widget.highscoresCtrl.images['assets/icons/battleye_type/$type.png'];
    if (image == null) return _infoIcon(child: Container());
    return _infoIcon(child: Image(image: image));
  }

  Widget _pvpType() {
    final String? type = widget.item.world?.pvpType?.toLowerCase().replaceAll(' ', '_');
    final AssetImage? image = widget.highscoresCtrl.images['assets/icons/pvp_type/$type.png'];
    if (image == null) return _infoIcon(child: Container());
    return _infoIcon(child: Image(image: image));
  }

  Widget _globalRank() => _infoIcon(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //
            _globalRankImage(),

            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                _globalRankValue ?? '',
                style: const TextStyle(
                  fontSize: 11,
                  height: 13 / 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bgDefault,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _globalRankImage() {
    final int length = (_globalRankValue ?? ' ').length;
    final AssetImage? image = widget.highscoresCtrl.images['assets/icons/rank/globalrank$length.png'];
    if (image == null) return Container();
    return Image(image: image);
  }

  String? get _globalRankValue {
    if (widget.highscoresCtrl.category.value == 'Experience gained') {
      return (widget.highscoresCtrl.rawList.indexOf(widget.item) + 1).toString();
    }
    if (widget.highscoresCtrl.category.value == 'Online time') {
      return (widget.highscoresCtrl.rawList.indexOf(widget.item) + 1).toString();
    }
    return widget.item.rank.toString();
  }

  Future<void> _loadCharacter(BuildContext context) async {
    if (widget.item.name == null) return;
    widget.characterCtrl.searchCtrl.text = widget.item.name!;
    Get.toNamed(Routes.character.name);
    widget.characterCtrl.searchCharacter();
  }
}
