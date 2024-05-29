import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/online_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/views/pages/online/components/online_entry_widget.dart';
import 'package:forgottenland/views/pages/online/components/online_filters_widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class OnlineCharactersPage extends StatefulWidget {
  @override
  State<OnlineCharactersPage> createState() => _OnlineCharactersPageState();
}

class _OnlineCharactersPageState extends State<OnlineCharactersPage> {
  final OnlineController onlineCtrl = Get.find<OnlineController>();

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'online',
        postFrameCallback: onlineCtrl.getOnlineCharacters,
        onRefresh: onlineCtrl.getOnlineCharacters,
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: Column(
          children: <Widget>[
            //
            OnlineFilters(),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _body(),
            ),
          ],
        ),
      );

  Widget _body() => Obx(
        () {
          if (onlineCtrl.isLoading.value) return _loading();
          if (onlineCtrl.filteredList.isNotEmpty) return _listBuilder();
          if (!onlineCtrl.isLoading.value) return _reloadButton();
          return Container();
        },
      );

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

  Widget _listBuilder() => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: onlineCtrl.filteredList.length,
        itemBuilder: _itemBuilder,
        shrinkWrap: true,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final HighscoresEntry entry = onlineCtrl.filteredList[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: OnlineEntryWidget(entry),
    );
  }

  Widget _reloadButton() => GestureDetector(
        onTap: onlineCtrl.getOnlineCharacters,
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(30),
          child: Icon(
            Icons.refresh,
            size: 40,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
        ),
      );
}
