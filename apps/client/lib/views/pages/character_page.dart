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
import 'package:models/models.dart';
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

  Widget _loading() => Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(37.5),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
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
          if (characterCtrl.character.value.achievements?.isNotEmpty ?? false) _achievements(),
          if (characterCtrl.character.value.rookmaster != null) _rookMaster(),
          if (characterCtrl.character.value.experienceGained != null) _experienceGained(),
          if (characterCtrl.character.value.onlinetime != null) _onlineTime(),
          if (characterCtrl.character.value.data?.name != null) _buttonViewOfficialWebsite(),
        ],
      );

  Widget _section({
    required String title,
    required List<Map<String, String>> list,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16),
          _title(title),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (_, int index) => ColoredBox(
                color: index.isOdd ? AppColors.bgPaper : AppColors.bgPaper.withOpacity(0.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: _info(list[index]['name'] ?? ''),
                    ),
                    if (list[index]['value'] != null) ...<Widget>[
                      const SizedBox(width: 1),
                      Flexible(
                        flex: MediaQuery.of(context).size.width >= 600 ? 4 : 3,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: AppColors.bgDefault,
                              ),
                            ),
                          ),
                          child: _info(list[index]['value'] ?? ''),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget _title(String title) => Container(
        height: 22,
        padding: const EdgeInsets.only(left: 3),
        child: SelectableText(
          title,
          style: const TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _info(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        alignment: Alignment.centerLeft,
        child: BetterText(
          text,
          style: const TextStyle(
            fontSize: 13,
            height: 16 / 13,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _about() {
    final CharacterData? data = characterCtrl.character.value.data;

    return _section(
      title: 'Character information',
      list: <Map<String, String>>[
        <String, String>{'name': 'Name:', 'value': data?.name ?? ''},
        <String, String>{'name': 'Title:', 'value': data?.title ?? ''},
        <String, String>{'name': 'Sex:', 'value': data?.sex ?? ''},
        <String, String>{'name': 'Level:', 'value': data?.level?.toString() ?? ''},
        // <String, String>{
        //   'name': 'Achievement Points:',
        //   'value': data?.achievementPoints?.toString() ?? '',
        // },
        <String, String>{'name': 'World:', 'value': data?.world ?? ''},
        if (data?.comment != null) <String, String>{'name': 'Comment:', 'value': data?.comment ?? ''},
      ],
    );
  }

  Widget _achievements() => _section(
        title: 'Account achievements',
        list: characterCtrl.character.value.achievements
                ?.map((Achievements e) => <String, String>{'name': e.name ?? ''})
                .toList() ??
            <Map<String, String>>[],
      );

  Widget _rookMaster() => _section(
        title: 'Rook Master',
        list: <Map<String, String>>[
          <String, String>{
            'name': 'Rank:',
            'value': '<blue>${characterCtrl.character.value.rookmaster?.rank ?? ''}<blue>',
          },
          <String, String>{
            'name': 'Points:',
            'value': '<blue>${characterCtrl.character.value.rookmaster?.stringValue ?? ''}<blue>',
          },
        ],
      );

  Widget _experienceGained() {
    final HighscoresEntryTimeframes? experienceGained = characterCtrl.character.value.experienceGained;
    return _section(
      title: 'Experience gained',
      list: <Map<String, String>>[
        if (experienceGained?.today?.stringValue != null)
          <String, String>{
            'name': 'Today:',
            'value': '<green>+${experienceGained?.today?.stringValue ?? ''}<green>',
          },
        if (experienceGained?.yesterday?.stringValue != null)
          <String, String>{
            'name': 'Yesterday:',
            'value': '<green>+${experienceGained?.yesterday?.stringValue ?? ''}<green>',
          },
        if (experienceGained?.last7days?.stringValue != null)
          <String, String>{
            'name': '7 days:',
            'value': '<green>+${experienceGained?.last7days?.stringValue ?? ''}<green>',
          },
        if (experienceGained?.last30days?.stringValue != null)
          <String, String>{
            'name': '30 days:',
            'value': '<green>+${experienceGained?.last30days?.stringValue ?? ''}<green>',
          },
        if (experienceGained?.last365days?.stringValue != null)
          <String, String>{
            'name': '365 days:',
            'value': '<green>+${experienceGained?.last365days?.stringValue ?? ''}<green>',
          },
      ],
    );
  }

  Widget _onlineTime() {
    final HighscoresEntryTimeframes? onlinetime = characterCtrl.character.value.onlinetime;
    return _section(
      title: 'Online Time',
      list: <Map<String, String>>[
        if (onlinetime?.today?.onlineTime != null)
          <String, String>{
            'name': 'Today:',
            'value': '<yellow>${onlinetime?.today?.onlineTime ?? ''}<yellow>',
          },
        if (onlinetime?.yesterday?.onlineTime != null)
          <String, String>{
            'name': 'Yesterday:',
            'value': '<yellow>${onlinetime?.yesterday?.onlineTime ?? ''}<yellow>',
          },
        if (onlinetime?.last7days?.onlineTime != null)
          <String, String>{
            'name': '7 days:',
            'value': '<yellow>${onlinetime?.last7days?.onlineTime ?? ''}<yellow>',
          },
        if (onlinetime?.last30days?.onlineTime != null)
          <String, String>{
            'name': '30 days:',
            'value': '<yellow>${onlinetime?.last30days?.onlineTime ?? ''}<yellow>',
          },
        if (onlinetime?.last365days?.onlineTime != null)
          <String, String>{
            'name': '365 days:',
            'value': '<yellow>${onlinetime?.last365days?.onlineTime ?? ''}<yellow>',
          },
      ],
    );
  }

  Widget _buttonViewOfficialWebsite() => ClickableContainer(
        onTap: () => launchUrlString(
          'https://www.tibia.com/community/?subtopic=characters&name=${characterCtrl.character.value.data?.name}',
        ),
        padding: const EdgeInsets.all(12),
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
