import 'package:flutter/material.dart';
import 'package:forgottenland/modules/npcs/controllers/npcs_controller.dart';
import 'package:forgottenland/modules/npcs/views/components/npc_widget.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/theme/theme.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:forgottenland/views/widgets/src/other/error_builder.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class NpcsPage extends StatefulWidget {
  @override
  State<NpcsPage> createState() => _NpcsPageState();
}

class _NpcsPageState extends State<NpcsPage> {
  NpcsController npcsCtrl = Get.find<NpcsController>();

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'npcs',
        postFrameCallback: npcsCtrl.getAll,
        onRefresh: npcsCtrl.getAll,
        body: Column(
          children: <Widget>[
            _title(),
            _divider(),
            _body(),
          ],
        ),
      );

  Widget _title() => SelectableText(
        'Rookgaard NPCs transcripts',
        style: appTheme().textTheme.titleMedium,
      );

  Widget _divider() => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: const Divider(height: 1),
      );

  Widget _body() => Obx(
        () {
          if (npcsCtrl.isLoading.value) return _loading();
          if (npcsCtrl.response.error) {
            return ErrorBuilder(
              'Internal server error',
              reloadButtonText: 'Try again',
              onTapReload: npcsCtrl.getAll,
            );
          }
          return _listBuilder();
        },
      );

  Widget _loading() => Container(
        height: 110,
        width: 110,
        padding: const EdgeInsets.all(30),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _listBuilder() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: npcsCtrl.npcs.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final NPC npc = npcsCtrl.npcs[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: NpcWidget(npc),
    );
  }
}
