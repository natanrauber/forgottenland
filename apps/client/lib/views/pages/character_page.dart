import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/character_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:forgottenland/views/widgets/src/other/clickable_container.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CharacterPage extends StatefulWidget {
  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final CharacterController characterCtrl = Get.find<CharacterController>();

  Timer timer = Timer(Duration.zero, () {});
  bool expandRookMaster = false;

  @override
  Widget build(BuildContext context) => Obx(
        () => AppPage(
          screenName: 'character',
          body: Column(
            children: <Widget>[
              _searchField(),
              _body(),
            ],
          ),
        ),
      );

  CustomTextField _searchField() => CustomTextField(
        label: 'Character Name',
        controller: characterCtrl.searchCtrl,
        onChanged: (String? value) {
          if (timer.isActive) timer.cancel();
          if (value != null && value != '') {
            timer = Timer(
              const Duration(seconds: 1),
              () {
                dismissKeyboard(context);
                characterCtrl.searchCharacter();
              },
            );
          }
        },
      );

  Widget _body() {
    if (characterCtrl.isLoading.value) return _loading();
    if (characterCtrl.searchResponse.error) return _errorBuilder();
    return _characterData();
  }

  Widget _loading() => Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(35),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
        ),
      );

  Widget _errorBuilder() {
    if (characterCtrl.searchResponse.statusCode == 404) return ErrorBuilder('Character not found');
    if (characterCtrl.searchResponse.statusCode == 406) return ErrorBuilder('Character is not in Rookgaard');
    return ErrorBuilder(
      'Internal server error',
      reloadButtonText: 'Try again',
      onTapReload: characterCtrl.searchCharacter,
    );
  }

  Widget _characterData() => Column(
        children: <Widget>[
          if (characterCtrl.character.value.data?.name != null) _about(),
          if (characterCtrl.character.value.data?.comment != null) _comment(),
          if (characterCtrl.character.value.achievements?.isNotEmpty ?? false) _achievements(),
          if (characterCtrl.character.value.experienceGained != null) _experienceGained(),
          if (characterCtrl.character.value.onlinetime != null) _onlineTime(),
          if (characterCtrl.character.value.rookmaster != null) _rookMaster(),
          if (characterCtrl.character.value.data?.name != null) _buttonViewOfficialWebsite(),
        ],
      );

  Widget _section({required String title, required Widget child}) => Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(title),
            _divider(),
            child,
          ],
        ),
      );

  Widget _title(String text) => Center(
        child: SelectableText(text),
      );

  Widget _divider() => const Divider(
        height: 26,
        thickness: 1,
        color: AppColors.bgDefault,
      );

  Widget _info(String text) => Container(
        margin: const EdgeInsets.only(top: 5),
        child: SelectableText(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _about() => _section(
        title: 'Character information',
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _info('Name:'),
                _info('Sex:'),
                _info('World:'),
                _info('Level:'),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _info(characterCtrl.character.value.data?.name ?? '---'),
                _info(characterCtrl.character.value.data?.sex ?? '---'),
                _info(characterCtrl.character.value.data?.world ?? '---'),
                _info(characterCtrl.character.value.data?.level?.toString() ?? '---'),
              ],
            ),
          ],
        ),
      );

  Widget _comment() => _section(
        title: 'Comment',
        child: _info(characterCtrl.character.value.data?.comment ?? ''),
      );

  Widget _achievements() => _section(
        title: 'Account achievements',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if ((characterCtrl.character.value.achievements?.length ?? 0) >= 1)
              _info(characterCtrl.character.value.achievements?[0].name ?? '---'),
            if ((characterCtrl.character.value.achievements?.length ?? 0) >= 2)
              _info(characterCtrl.character.value.achievements?[1].name ?? '---'),
            if ((characterCtrl.character.value.achievements?.length ?? 0) >= 3)
              _info(characterCtrl.character.value.achievements?[2].name ?? '---'),
            if ((characterCtrl.character.value.achievements?.length ?? 0) >= 4)
              _info(characterCtrl.character.value.achievements?[3].name ?? '---'),
            if ((characterCtrl.character.value.achievements?.length ?? 0) >= 5)
              _info(characterCtrl.character.value.achievements?[4].name ?? '---'),
          ],
        ),
      );

  Widget _experienceGained() => _section(
        title: 'Experience gained',
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _info('Today: '),
                _info('Yesterday:'),
                _info('7 days:'),
                _info('30 days:'),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _info(characterCtrl.character.value.experienceGained?.today?.stringValue ?? '---'),
                _info(characterCtrl.character.value.experienceGained?.yesterday?.stringValue ?? '---'),
                _info(characterCtrl.character.value.experienceGained?.last7days?.stringValue ?? '---'),
                _info(characterCtrl.character.value.experienceGained?.last30days?.stringValue ?? '---'),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _info('#${characterCtrl.character.value.experienceGained?.today?.rank?.toString() ?? '---'}'),
                _info('#${characterCtrl.character.value.experienceGained?.yesterday?.rank?.toString() ?? '---'}'),
                _info('#${characterCtrl.character.value.experienceGained?.last7days?.rank?.toString() ?? '---'}'),
                _info('#${characterCtrl.character.value.experienceGained?.last30days?.rank?.toString() ?? '---'}'),
              ],
            ),
          ],
        ),
      );

  Widget _onlineTime() => _section(
        title: 'Online Time',
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _info('Today: '),
                _info('Yesterday:'),
                _info('7 days:'),
                _info('30 days:'),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _info(characterCtrl.character.value.onlinetime?.today?.onlineTime ?? '---'),
                _info(characterCtrl.character.value.onlinetime?.yesterday?.onlineTime ?? '---'),
                _info(characterCtrl.character.value.onlinetime?.last7days?.onlineTime ?? '---'),
                _info(characterCtrl.character.value.onlinetime?.last30days?.onlineTime ?? '---'),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _info('#${characterCtrl.character.value.onlinetime?.today?.rank?.toString() ?? '---'}'),
                _info('#${characterCtrl.character.value.onlinetime?.yesterday?.rank?.toString() ?? '---'}'),
                _info('#${characterCtrl.character.value.onlinetime?.last7days?.rank?.toString() ?? '---'}'),
                _info('#${characterCtrl.character.value.onlinetime?.last30days?.rank?.toString() ?? '---'}'),
              ],
            ),
          ],
        ),
      );

  Widget _rookMaster() => _section(
        title: 'Rook Master',
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info('Rank:'),
                    _info('Points:'),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info('#${characterCtrl.character.value.rookmaster?.rank ?? '---'}'),
                    _info(characterCtrl.character.value.rookmaster?.stringValue ?? '---'),
                  ],
                ),
              ],
            ),
            _divider(),
            Row(
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
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _info('${characterCtrl.character.value.rookmaster?.level ?? '---'}'),
                    _info('${characterCtrl.character.value.rookmaster?.expanded?.fist.value ?? '---'}'),
                    _info('${characterCtrl.character.value.rookmaster?.expanded?.axe.value ?? '---'}'),
                    _info('${characterCtrl.character.value.rookmaster?.expanded?.club.value ?? '---'}'),
                    _info('${characterCtrl.character.value.rookmaster?.expanded?.sword.value ?? '---'}'),
                    _info('${characterCtrl.character.value.rookmaster?.expanded?.distance.value ?? '---'}'),
                    _info('${characterCtrl.character.value.rookmaster?.expanded?.shielding.value ?? '---'}'),
                    _info('${characterCtrl.character.value.rookmaster?.expanded?.fishing.value ?? '---'}'),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.experience.position ?? '---'}'),
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.fist.position ?? '---'}'),
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.axe.position ?? '---'}'),
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.club.position ?? '---'}'),
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.sword.position ?? '---'}'),
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.distance.position ?? '---'}'),
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.shielding.position ?? '---'}'),
                    _info('#${characterCtrl.character.value.rookmaster?.expanded?.fishing.position ?? '---'}'),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.experience.points ?? '---'}'),
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.fist.points ?? '---'}'),
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.axe.points ?? '---'}'),
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.club.points ?? '---'}'),
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.sword.points ?? '---'}'),
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.distance.points ?? '---'}'),
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.shielding.points ?? '---'}'),
                    _info('+${characterCtrl.character.value.rookmaster?.expanded?.fishing.points ?? '---'}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buttonViewOfficialWebsite() => ClickableContainer(
        onTap: () => launchUrlString(
          'https://www.tibia.com/community/?subtopic=characters&name=${characterCtrl.character.value.data?.name}',
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 25),
        color: AppColors.bgPaper,
        hoverColor: AppColors.bgHover,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'View on Tibia.com',
              style: TextStyle(
                fontSize: 13,
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
      );
}
