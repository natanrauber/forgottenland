import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:forgottenland/rxmodels/world_rxmodel.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/instance_manager.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class OnlineController extends Controller {
  OnlineController(this.httpClient);

  final IHttpClient httpClient;

  WorldsController worldsCtrl = Get.find<WorldsController>();

  RxList<Supporter> supporters = <Supporter>[].obs;
  RxList<HighscoresEntry> rawList = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> filteredList = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> onlineTimes = <HighscoresEntry>[].obs;
  TextController searchController = TextController();
  RxWorld world = World(name: 'All').obs;
  RxString battleyeType = LIST.battleyeType.first.obs;
  RxString location = LIST.location.first.obs;
  RxString pvpType = LIST.pvpType.first.obs;
  RxString worldType = LIST.worldType.first.obs;
  RxBool enableBattleyeType = true.obs;
  RxBool enableLocation = true.obs;
  RxBool enablePvpType = true.obs;
  RxBool enableWorldType = true.obs;

  Future<void> getOnlineCharacters() async {
    if (isLoading.isTrue) return;
    isLoading.value = true;
    rawList.clear();

    if (worldsCtrl.list.isEmpty) await worldsCtrl.getWorlds();

    final MyHttpResponse response = await httpClient.get('${PATH.forgottenLandApi}/online/now');
    if (response.success) _populateList(rawList, response);

    await filterList();
    isLoading.value = false;
  }

  void _populateList(RxList<HighscoresEntry> list, MyHttpResponse response) {
    final Online online = Online.fromJson(
      (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
    );

    for (final OnlineEntry e in online.list) {
      final HighscoresEntry entry = HighscoresEntry.fromOnlineEntry(e);
      final World? world = worldsCtrl.list.getByName(e.world);
      if (world != null) entry.world = world;
      list.add(entry);
    }
  }

  Future<void> filterList() async {
    isLoading.value = true;

    filteredList.clear();

    for (final HighscoresEntry item in rawList) {
      bool valid = true;

      if (world.value.name != 'All') {
        if (world.value.name != item.world?.name) valid = false;
      }

      if (battleyeType.value != 'All') {
        if (battleyeType.value != item.world?.battleyeType) valid = false;
      }

      if (location.value != 'All') {
        if (item.world?.location != location.value) valid = false;
      }

      if (pvpType.value != 'All') {
        if (item.world?.pvpType?.toLowerCase() != pvpType.toLowerCase()) valid = false;
      }

      if (worldType.value != 'All') {
        if (item.world?.worldType?.toLowerCase() != worldType.toLowerCase()) valid = false;
      }

      if (searchController.text.isNotEmpty) {
        if (item.name?.toLowerCase().contains(searchController.text.toLowerCase()) != true) valid = false;
      }

      if (valid) filteredList.add(item);
    }

    isLoading.value = false;
  }

  Future<void> getOnlineTimes(String day) async {
    if (isLoading.isTrue) return;
    isLoading.value = true;
    onlineTimes.clear();

    if (worldsCtrl.list.isEmpty) await worldsCtrl.getWorlds();

    final MyHttpResponse response = await httpClient.get('${PATH.forgottenLandApi}/online/time/$day');
    if (response.success) _populateList(onlineTimes, response);

    isLoading.value = false;
  }
}
