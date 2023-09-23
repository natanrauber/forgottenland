import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:get/get.dart';

class CardDonate extends StatefulWidget {
  const CardDonate({super.key});

  @override
  State<CardDonate> createState() => _CardDonateState();
}

class _CardDonateState extends State<CardDonate> {
  final CharacterController characterCtrl = Get.find<CharacterController>();

  bool expanded = false;

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: _decoration,
        child: _body(),
      );

  BoxDecoration get _decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppColors.bgPaper,
        ),
      );

  Widget _body() => Flex(
        direction: expanded ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //
          SelectableText.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w200,
                color: AppColors.textSecondary,
              ),
              children: <InlineSpan>[
                //
                const TextSpan(
                  text: 'Please consider supporting us.',
                ),

                if (expanded)
                  const TextSpan(
                    text: ' You can do this by donating Tibia Coins to the character ',
                  ),

                if (expanded)
                  TextSpan(
                    text: 'Awkn',
                    style: const TextStyle(
                      color: AppColors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = _pushCharacterPage,
                  ),

                if (expanded)
                  const TextSpan(
                    text:
                        '. Any donation is appreciated and will be put toward the costs of maintaining our website. Your character will also display a supporter badge on our website. Thank you!',
                  ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          if (expanded) const SizedBox(height: 10),

          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => setState(() => expanded = !expanded),
              child: Text(
                !expanded ? 'See more' : 'See less',
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  fontWeight: FontWeight.w200,
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      );

  Future<void> _pushCharacterPage() async {
    characterCtrl.searchCtrl.text = 'Awkn';
    Get.toNamed(Routes.character.name);
    characterCtrl.searchCharacter();
  }
}
