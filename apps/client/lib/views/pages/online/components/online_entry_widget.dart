import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/better_text.dart';
import 'package:forgottenland/views/widgets/src/other/blinking_circle.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class OnlineEntryWidget extends StatefulWidget {
  const OnlineEntryWidget(this.item);

  final HighscoresEntry item;

  @override
  State<OnlineEntryWidget> createState() => _OnlineEntryWidgetState();
}

class _OnlineEntryWidgetState extends State<OnlineEntryWidget> {
  final CharacterController characterCtrl = Get.find<CharacterController>();

  @override
  Widget build(BuildContext context) => ClickableContainer(
        onTap: _onTap,
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
                        const BlinkingCircle(size: 12),

                        const SizedBox(width: 4),

                        Expanded(child: _name()),
                      ],
                    ),
                  ),

                  _info('World: ${widget.item.world?.name ?? ''}'),

                  _info('Level: ${widget.item.level ?? ''}'),

                  if (widget.item.supporterTitle != null)
                    _info('\n<primary>${widget.item.supporterTitle ?? ''}<primary>'),
                ],
              ),
            ),

            _infoIcons(context),
          ],
        ),
      );

  void _onTap() {
    dismissKeyboard(context);
    _loadCharacter();
  }

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: widget.item.supporterTitle == null ? null : Border.all(color: AppColors.primary),
      );

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

  Widget _infoIcons(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //
          _battleyeTypeIcon(),

          _pvpType(),
        ],
      );

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

  Future<void> _loadCharacter() async {
    if (widget.item.name == null) return;
    characterCtrl.searchCtrl.text = widget.item.name!;
    Get.toNamed(Routes.character.name);
    characterCtrl.searchCharacter();
  }
}
