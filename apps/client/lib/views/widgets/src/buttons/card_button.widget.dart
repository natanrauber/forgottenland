import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';

class CardButton extends StatefulWidget {
  const CardButton({
    this.onTap,
    this.globalRank,
    this.title,
    this.description,
    this.descriptionMaxLines = 10,
    this.descriptionStyle,
    this.child,
    this.color = AppColors.bgPaper,
  });

  final Function()? onTap;
  final int? globalRank;
  final String? title;
  final String? description;
  final int? descriptionMaxLines;
  final TextStyle? descriptionStyle;
  final Widget? child;
  final Color color;

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            decoration: _decoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //
                      _cardButtonTitle(),

                      if (widget.description != null) _cardButtonDescription(),

                      widget.child ?? Container(),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                if (widget.onTap != null) _chevronIcon(),
              ],
            ),
          ),
        ),
      );

  void _onTap() {
    dismissKeyboard(context);
    widget.onTap?.call();
  }

  BoxDecoration get _decoration => BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(11),
      );

  Widget _cardButtonTitle() => Text(
        widget.title ?? '',
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
      );

  Icon _chevronIcon() => const Icon(
        CupertinoIcons.chevron_right,
        size: 20,
        color: AppColors.primary,
      );

  Widget _cardButtonDescription() => SelectableText(
        widget.description ?? '',
        maxLines: widget.descriptionMaxLines,
        style: widget.descriptionStyle ??
            const TextStyle(
              color: AppColors.primary,
              overflow: TextOverflow.ellipsis,
            ),
      );
}
