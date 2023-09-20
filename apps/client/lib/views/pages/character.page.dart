import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:utils/utils.dart';

class CharacterPage extends StatefulWidget {
  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final CharacterController characterCtrl = Get.find<CharacterController>();

  final TextController controller = TextController();
  Timer timer = Timer(Duration.zero, () {});

  Future<void> _getCharacter(String name) async => characterCtrl.get(name);

  @override
  Widget build(BuildContext context) => Obx(
        () => AppPage(
          body: Column(
            children: <Widget>[
              _searchField(),

              /// card - character information
              if (characterCtrl.data.value.data?.name != null) _about(),

              /// card - comment
              if (characterCtrl.data.value.data?.comment != null) _comment(),

              /// card - achievements
              if (characterCtrl.data.value.achievements?.isNotEmpty ?? false) _achievements(),

              if (characterCtrl.data.value.experienceGained != null) _experienceGained(),

              /// card - tibia.com link
              if (characterCtrl.data.value.data?.name != null) _buttonViewOfficialWebsite(),
            ],
          ),
        ),
      );

  CustomTextField _searchField() => CustomTextField(
        label: 'Character Name',
        controller: controller,
        onChanged: (String? value) {
          if (timer.isActive) timer.cancel();
          if (value != null && value != '') {
            timer = Timer(
              const Duration(seconds: 1),
              () => _getCharacter(value),
            );
          }
        },
      );

  Container _about() => Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          children: <Widget>[
            const SelectableText(
              'Character information',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Divider(
              thickness: 1,
              color: AppColors.bgDefault,
            ),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: BetterText(
                      '<primary>${characterCtrl.data.value.data?.name ?? ''}<primary>',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: SelectableText(
                      characterCtrl.data.value.data?.sex?.capitalize() ?? '',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: SelectableText(
                      'Level ${characterCtrl.data.value.data?.level ?? ''}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: SelectableText(
                      '${characterCtrl.data.value.data?.achievementPoints ?? ''} Achievement Points',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: SelectableText(
                      'Inhabitant of ${characterCtrl.data.value.data?.world ?? ''}',
                    ),
                  ),
                  if (characterCtrl.data.value.data?.guild?.name != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: SelectableText(
                        '${characterCtrl.data.value.data?.guild?.rank ?? ''} of the ${characterCtrl.data.value.data?.guild?.name ?? ''}',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Container _comment() => Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          children: <Widget>[
            const SelectableText(
              'Comment',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Divider(
              thickness: 1,
              color: AppColors.bgDefault,
            ),
            SizedBox(
              width: double.maxFinite,
              child: SelectableText(
                characterCtrl.data.value.data?.comment ?? '',
              ),
            ),
          ],
        ),
      );

  Container _achievements() => Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          children: <Widget>[
            const SelectableText(
              'Account achievements',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Divider(
              thickness: 1,
              color: AppColors.bgDefault,
            ),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if ((characterCtrl.data.value.achievements?.length ?? 0) >= 1)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: SelectableText(
                        characterCtrl.data.value.achievements?[0].name ?? 'achievementName',
                      ),
                    ),
                  if ((characterCtrl.data.value.achievements?.length ?? 0) >= 2)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: SelectableText(
                        characterCtrl.data.value.achievements?[1].name ?? 'achievementName',
                      ),
                    ),
                  if ((characterCtrl.data.value.achievements?.length ?? 0) >= 3)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: SelectableText(
                        characterCtrl.data.value.achievements?[2].name ?? 'achievementName',
                      ),
                    ),
                  if ((characterCtrl.data.value.achievements?.length ?? 0) >= 4)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: SelectableText(
                        characterCtrl.data.value.achievements?[3].name ?? 'achievementName',
                      ),
                    ),
                  if ((characterCtrl.data.value.achievements?.length ?? 0) >= 5)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: SelectableText(
                        characterCtrl.data.value.achievements?[4].name ?? 'achievementName',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _experienceGained() => Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          children: <Widget>[
            const SelectableText(
              'Experience gained',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Divider(
              height: 26,
              thickness: 1,
              color: AppColors.bgDefault,
            ),
            Row(
              children: <Widget>[
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SelectableText(
                      'Today: ',
                    ),
                    SelectableText(
                      'Yesterday:',
                    ),
                    SelectableText(
                      '7 days:',
                    ),
                    SelectableText(
                      '30 days:',
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.today?.value ?? '---',
                    ),
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.yesterday?.value ?? '---',
                    ),
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.last7days?.value ?? '---',
                    ),
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.last30days?.value ?? '---',
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.today?.rank != null
                          ? '#${characterCtrl.data.value.experienceGained?.today?.rank?.toString() ?? ''}'
                          : '---',
                    ),
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.yesterday?.rank != null
                          ? '#${characterCtrl.data.value.experienceGained?.yesterday?.rank?.toString() ?? ''}'
                          : '---',
                    ),
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.last7days?.rank != null
                          ? '#${characterCtrl.data.value.experienceGained?.last7days?.rank?.toString() ?? ''}'
                          : '---',
                    ),
                    SelectableText(
                      characterCtrl.data.value.experienceGained?.last30days?.rank != null
                          ? '#${characterCtrl.data.value.experienceGained?.last30days?.rank?.toString() ?? ''}'
                          : '---',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  MouseRegion _buttonViewOfficialWebsite() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrlString(
            'https://www.tibia.com/community/?subtopic=characters&name=${characterCtrl.data.value.data?.name}',
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 25),
            decoration: BoxDecoration(
              color: AppColors.bgPaper,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'View on Tibia.com',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
                Icon(
                  CupertinoIcons.arrow_up_right_square,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      );
}
