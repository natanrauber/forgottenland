import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/modules/npcs/controllers/npcs_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/views/widgets/src/images/web_image.dart';
import 'package:forgottenland/views/widgets/src/other/better_text.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class NpcWidget extends StatefulWidget {
  const NpcWidget(this.npc);

  final NPC npc;

  @override
  State<NpcWidget> createState() => _NpcWidgetState();
}

class _NpcWidgetState extends State<NpcWidget> {
  bool isLoading = false;
  bool expandedView = false;

  NpcsController npcsCtrl = Get.find<NpcsController>();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
        decoration: _decoration(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _sprite(),
                      const SizedBox(width: 10),
                      Expanded(child: _name()),
                      const SizedBox(width: 5),
                      _toggleViewButton(),
                    ],
                  ),
                  if (expandedView) _divider(),
                  if (expandedView) _text(),
                ],
              ),
            ),
          ],
        ),
      );

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.bgPaper),
      );

  Widget _sprite() => WebImage(
        widget.npc.imgUrl,
        backgroundColor: AppColors.bgPaper,
        borderColor: AppColors.bgPaper,
      );

  Widget _name() {
    if (expandedView) {
      return SelectableText(
        widget.npc.name ?? '',
        style: const TextStyle(
          fontSize: 13,
          height: 16 / 13,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.left,
      );
    }

    return Text(
      widget.npc.name ?? '',
      style: const TextStyle(
        fontSize: 13,
        height: 32 / 13,
        color: AppColors.primary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _divider() => Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
        child: const Divider(height: 1, color: AppColors.bgDefault),
      );

  Widget _text() => BetterText(
        _resultText,
        style: const TextStyle(
          fontSize: 12,
          height: 18 / 12,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.left,
      );

  String get _resultText {
    if (widget.npc.transcripts == null) return 'There are no records of known dialogues from this NPC.';
    final StringBuffer buffer = StringBuffer();
    final List<String> aux = (widget.npc.transcripts ?? '').split('\n');
    for (String e in aux) {
      e = e.contains('Player:') ? '<blue>$e<blue>' : '<lBlue>$e<lBlue>';
      buffer.write('\n$e');
    }
    return buffer.toString();
  }

  Widget _toggleViewButton() => ClickableContainer(
        onTap: _toggleView,
        height: 32,
        width: 32,
        alignment: Alignment.center,
        color: AppColors.bgPaper,
        hoverColor: AppColors.bgHover,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: isLoading
            ? _loading()
            : Icon(
                expandedView ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                size: 17,
              ),
      );

  Future<void> _toggleView() async {
    if (expandedView) return setState(() => expandedView = false);
    if (!expandedView && widget.npc.transcripts != null) return setState(() => expandedView = true);

    setState(() => isLoading = true);
    await npcsCtrl.getTranscripts(widget.npc);
    setState(() {
      isLoading = false;
      expandedView = true;
    });
  }

  Widget _loading() => const SizedBox(
        height: 17,
        width: 17,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
}
