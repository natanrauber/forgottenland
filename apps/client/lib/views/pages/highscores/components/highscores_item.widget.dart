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
  const HighscoresItemCard(this.index, this.item);

  final int index;
  final HighscoresEntry item;

  @override
  State<HighscoresItemCard> createState() => _HighscoresItemCardState();
}

class _HighscoresItemCardState extends State<HighscoresItemCard> {
  final CharacterController characterCtrl = Get.find<CharacterController>();
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final UserController userCtrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPattern();
    final bool hideData =
        LIST.premiumCategories.contains(highscoresCtrl.category.value) && userCtrl.isLoggedIn.value != true;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onTap(context),
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
                        '$_rankName: ${hideData ? '<primary>???<primary>' : formatter.format(_rankValue)}',
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

  void _onTap(BuildContext context) {
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
            Image.asset(
              'assets/icons/rank/rank${(widget.index + 1).toString().length}.png',
            ),

            Text(
              '${widget.index + 1}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.black80,
              ),
            )
          ],
        ),
      );

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

  int? get _rankValue {
    if (highscoresCtrl.category.value == 'Rook Master') return widget.item.expanded?.points;
    return widget.item.value;
  }

  Widget _skillsPosition(HighscoresEntry entry) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _info(
            'Level: ${entry.level ?? 'n/a'} ${entry.expanded?.experience.position == null ? '' : '(${entry.expanded?.experience.position}º)'} +${entry.expanded?.experience.points ?? 0}pts',
          ),
          _info(
            'Fist: ${entry.expanded?.fist.value ?? 'n/a'} ${entry.expanded?.fist.position == null ? '' : '(${entry.expanded?.fist.position}º)'} +${entry.expanded?.fist.points ?? 0}pts',
          ),
          _info(
            'Axe: ${entry.expanded?.axe.value ?? 'n/a'} ${entry.expanded?.axe.position == null ? '' : '(${entry.expanded?.axe.position}º)'} +${entry.expanded?.axe.points ?? 0}pts',
          ),
          _info(
            'Club: ${entry.expanded?.club.value ?? 'n/a'} ${entry.expanded?.club.position == null ? '' : '(${entry.expanded?.club.position}º)'} +${entry.expanded?.club.points ?? 0}pts',
          ),
          _info(
            'Sword: ${entry.expanded?.sword.value ?? 'n/a'} ${entry.expanded?.sword.position == null ? '' : '(${entry.expanded?.sword.position}º)'} +${entry.expanded?.sword.points ?? 0}pts',
          ),
          _info(
            'Distance: ${entry.expanded?.distance.value ?? 'n/a'} ${entry.expanded?.distance.position == null ? '' : '(${entry.expanded?.distance.position}º)'} +${entry.expanded?.distance.points ?? 0}pts',
          ),
          _info(
            'Shielding: ${entry.expanded?.shielding.value ?? 'n/a'} ${entry.expanded?.shielding.position == null ? '' : '(${entry.expanded?.shielding.position}º)'} +${entry.expanded?.shielding.points ?? 0}pts',
          ),
          _info(
            'Fishing: ${entry.expanded?.fishing.value ?? 'n/a'} ${entry.expanded?.fishing.position == null ? '' : '(${entry.expanded?.fishing.position}º)'} +${entry.expanded?.fishing.points ?? 0}pts',
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
    if (highscoresCtrl.category.value == 'Experience gained') return false;
    if (highscoresCtrl.category.value == 'Online time') return false;
    if ((widget.index + 1) != widget.item.rank) return true;
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
          children: <Widget>[
            //
            Image.asset(
              'assets/icons/rank/globalrank${((widget.item.rank ?? 0) + 1).toString().length}.png',
            ),

            Container(
              padding: const EdgeInsets.only(left: 20, top: 1.5),
              child: Text(
                '${widget.item.rank ?? ''}',
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

  Future<void> _loadCharacter(BuildContext context) async {
    if (widget.item.name == null) return;
    await characterCtrl.get(widget.item.name!);
    Get.toNamed(Routes.character.name);
  }
}
