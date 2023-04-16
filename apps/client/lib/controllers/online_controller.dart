import 'package:dio/dio.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:forgottenland/rxmodels/world_rxmodel.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/instance_manager.dart';
import 'package:models/models.dart';

class OnlineController extends Controller {
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

    if (worldsCtrl.list.isEmpty) await worldsCtrl.load();

    final Response<dynamic>? response = await Http().get('/online', baseUrl: PATH.forgottenLandApi);
    if (response?.statusCode == 200) _populateList(rawList, response);

    isLoading.value = false;
    return filterList();
  }

  void _populateList(RxList<HighscoresEntry> list, Response<dynamic>? response) {
    if (response?.data is! Map<String, dynamic>) return;
    if (response?.data['data'] is! Map<String, dynamic>) return;
    if (response?.data['data']['players'] is! Map<String, dynamic>) return;
    if (response?.data['data']['players']['online_players'] is! List<dynamic>) return;

    for (final dynamic e in response?.data['data']['players']['online_players'] as List<dynamic>) {
      if (e is Map<String, dynamic>) {
        final HighscoresEntry entry = HighscoresEntry.fromJson(e);
        final World? world = worldsCtrl.list.getByName(entry.world?.name);
        if (world != null) entry.world = world;
        list.add(entry);
      }
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

    if (worldsCtrl.list.isEmpty) await worldsCtrl.load();

    final Response<dynamic>? response = await Http().get('/onlinetime/$day', baseUrl: PATH.forgottenLandApi);
    if (response?.statusCode == 200) _populateList(onlineTimes, response);

    isLoading.value = false;
  }
}
