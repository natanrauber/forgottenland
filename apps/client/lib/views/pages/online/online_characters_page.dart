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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => onlineCtrl.getOnlineCharacters());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AppPage(
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
          height: 110,
          width: 110,
          padding: const EdgeInsets.all(30),
          child: const Icon(
            Icons.refresh,
            size: 50,
            color: AppColors.bgPaper,
          ),
        ),
      );
}
