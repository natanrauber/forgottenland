import 'package:flutter/material.dart';
import 'package:forgottenland/modules/bazaar/controllers/bazaar_controller.dart';
import 'package:forgottenland/modules/bazaar/views/components/auction_widget.dart';
import 'package:forgottenland/modules/bazaar/views/components/bazaar_filter_widget.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class BazaarPage extends StatefulWidget {
  @override
  State<BazaarPage> createState() => _BazaarPageState();
}

class _BazaarPageState extends State<BazaarPage> {
  final BazaarController bazaarCtrl = Get.find<BazaarController>();

  @override
  Widget build(BuildContext context) => AppPage(
        postFrameCallback: bazaarCtrl.getAuctions,
        onRefresh: bazaarCtrl.getAuctions,
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: Column(
          children: <Widget>[
            BazaarFilters(),
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
          if (bazaarCtrl.isLoading.value) return _loading();
          if (bazaarCtrl.filteredList.isNotEmpty) return _listBuilder();
          if (!bazaarCtrl.isLoading.value) return _reloadButton();
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
        itemCount: bazaarCtrl.filteredList.length,
        itemBuilder: _itemBuilder,
        shrinkWrap: true,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final Auction entry = bazaarCtrl.filteredList[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: AuctionWidget(entry),
    );
  }

  Widget _reloadButton() => GestureDetector(
        onTap: bazaarCtrl.getAuctions,
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
