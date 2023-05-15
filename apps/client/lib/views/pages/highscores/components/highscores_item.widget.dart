import 'package:flutter/cupertino.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/controllers/highscores_controller.dart';
import 'package:forgottenland/controllers/user_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/better_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class HighscoresItemCard extends StatefulWidget {
  const HighscoresItemCard(this.index, this.item, {this.disableOnTap = false});

  final int index;
  final HighscoresEntry item;
  final bool disableOnTap;

  @override
  State<HighscoresItemCard> createState() => _HighscoresItemCardState();
}

class _HighscoresItemCardState extends State<HighscoresItemCard> {
  final CharacterController characterCtrl = Get.find<CharacterController>();
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final UserController userCtrl = Get.find<UserController>();

  bool expand = false;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPattern();
    final bool hideData =
        LIST.premiumCategories.contains(highscoresCtrl.category.value) && userCtrl.isLoggedIn.value != true;

    return MouseRegion(
      cursor: widget.disableOnTap ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.disableOnTap ? null : _onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
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

                          _name(),
                        ],
                      ),
                    ),

                    if (highscoresCtrl.world.value.name == 'All') _info('World: ${widget.item.world?.name ?? ''}'),

                    if (highscoresCtrl.category.value != 'Rook Master') _info('Level: ${widget.item.level ?? ''}'),

                    if (widget.item.onlineTime != null) _info('Online time: ${widget.item.onlineTime ?? ''}'),

                    if (widget.item.value != null)
                      _info(
                        '$_rankName: ${hideData ? '<primary>???<primary>' : formatter.format(widget.item.value)}',
                      ),

                    if (highscoresCtrl.category.value == 'Rook Master') _skillsPosition(widget.item),

                    // if (widget.item.supporterTitle != null)
                    //   _info('\n<primary>${widget.item.supporterTitle ?? ''}<primary>'),
                  ],
                ),
              ),

              _infoIcons(context),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    dismissKeyboard(context);
    _loadCharacter(context);
  }

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: widget.item.supporterTitle != null ? AppColors.primary : AppColors.bgPaper),
      );

  Widget _rank() => SizedBox(
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //
            Image.asset('assets/icons/rank/rank${(_rankValue ?? ' ').length}.png'),

            Text(
              _rankValue ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.black80,
              ),
            ),
          ],
        ),
      );

  String? get _rankValue {
    if (_showGlobalRank) return (widget.index + 1).toString();
    if (highscoresCtrl.category.value == 'Experience gained') return (widget.index + 1).toString();
    if (highscoresCtrl.category.value == 'Online time') return (widget.index + 1).toString();
    return widget.item.rank?.toString();
  }

  Widget _name() => Text(
        widget.item.name ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      );

  Widget _info(String text) => Container(
        margin: const EdgeInsets.only(top: 5),
        child: BetterText(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      );

  String get _rankName {
    final String name = highscoresCtrl.category.value;
    if (name == 'Rook Master') return 'Total points';
    return name;
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
    if (highscoresCtrl.rawList.length != highscoresCtrl.filteredList.length) return true;
    return false;
  }

  Widget _infoIcon({required Widget child}) => Container(
        height: 20,
        margin: const EdgeInsets.only(bottom: 4),
        child: child,
      );

  Widget _battleyeTypeIcon() => _infoIcon(
        child: Image.asset(
          'assets/icons/battleye_type/${widget.item.world?.battleyeType?.toLowerCase()}.png',
        ),
      );

  Widget _pvpType() => _infoIcon(
        child: Image.asset(
          'assets/icons/pvp_type/${widget.item.world?.pvpType?.toLowerCase().replaceAll(' ', '_')}.png',
        ),
      );

  Widget _globalRank() => _infoIcon(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //
            Image.asset('assets/icons/rank/globalrank${(_globalRankValue ?? ' ').length}.png'),

            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                _globalRankValue ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black80,
                ),
              ),
            )
          ],
        ),
      );

  String? get _globalRankValue {
    if (highscoresCtrl.category.value == 'Experience gained') {
      return (highscoresCtrl.rawList.indexOf(widget.item) + 1).toString();
    }
    if (highscoresCtrl.category.value == 'Online time') {
      return (highscoresCtrl.rawList.indexOf(widget.item) + 1).toString();
    }
    return widget.item.rank.toString();
  }

  Future<void> _loadCharacter(BuildContext context) async {
    if (widget.item.name == null) return;
    await characterCtrl.get(widget.item.name!);
    Get.toNamed(Routes.character.name);
  }
}
