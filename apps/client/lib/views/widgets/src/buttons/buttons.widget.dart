import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            dismissKeyboard(context);
            onTap?.call();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.bgDefault,
              ),
            ),
          ),
        ),
      );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 20, bottom: 34),
        child: GestureDetector(
          onTap: () {
            dismissKeyboard(context);
            onTap?.call();
          },
          child: SelectableText(
            text,
            style: const TextStyle(
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
