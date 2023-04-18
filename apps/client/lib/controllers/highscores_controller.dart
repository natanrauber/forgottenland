import 'package:database_client/database_client.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/controllers/online_controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:forgottenland/rxmodels/world_rxmodel.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/instance_manager.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class HighscoresController extends Controller {
  final OnlineController _onlineCtrl = Get.find<OnlineController>();
  final WorldsController _worldsCtrl = Get.find<WorldsController>();

  DateTime _loadStartTime = DateTime.now();

  RxInt pageCtrl = 1.obs;

  RxList<Supporter> supporters = <Supporter>[].obs;
  RxList<String> hidden = <String>[].obs;
  RxList<HighscoresEntry> rawList = <HighscoresEntry>[].obs;
  TextController searchController = TextController();
  RxList<HighscoresEntry> filteredList = <HighscoresEntry>[].obs;
  RxString category = LIST.category.first.obs;
  RxString period = LIST.period.first.obs;
  RxWorld world = World(name: 'All').obs;
  RxString battleyeType = LIST.battleyeType.first.obs;
  RxString location = LIST.location.first.obs;
  RxString pvpType = LIST.pvpType.first.obs;
  RxString worldType = LIST.worldType.first.obs;
  RxBool enableBattleyeType = true.obs;
  RxBool enableLocation = true.obs;
  RxBool enablePvpType = true.obs;
  RxBool enableWorldType = true.obs;
  RxBool loadedAll = false.obs;

  bool get _shouldLoadMore {
    if (loadedAll.value) return false;
    if (DateTime.now().difference(_loadStartTime).inSeconds > 10) return false;
    if (searchController.text.isNotEmpty) return filteredList.isEmpty;
    return rawList.length < 1000 && filteredList.length < 10;
  }

  Future<void> loadHighscores({bool newPage = false, bool resetTimer = true}) async {
    MyHttpResponse response;

    pageCtrl.value = newPage ? pageCtrl.value + 1 : 1;
    if (!newPage) loadedAll = false.obs;
    if (pageCtrl.value > 20) return;
    if (pageCtrl.value == 1) rawList.clear();
    if (pageCtrl.value == 1) filteredList.clear();
    if (resetTimer) _loadStartTime = DateTime.now();
    if (DateTime.now().difference(_loadStartTime).inSeconds > 10) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    if (_worldsCtrl.list.isEmpty) await _worldsCtrl.load();

    try {
      String cat = category.value;
      if (cat == 'Experience gained') cat = '$cat+$period';
      if (cat == 'Online time') cat = '$cat+$period';

      response = await MyHttpClient().get(
        '${PATH.forgottenLandApi}/highscores/$world/$cat/none/$pageCtrl'.toLowerCase().replaceAll(' ', ''),
      );

      if (response.success) {
        final Record aux = Record.fromJson(
          (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        );
        _onlineCtrl.onlineTimes = <HighscoresEntry>[].obs;
        if (category.value == 'Experience gained') {
          if (period.value == 'Today') await _onlineCtrl.getOnlineTimes(MyDateTime.today());
          if (period.value == 'Yesterday') await _onlineCtrl.getOnlineTimes(MyDateTime.yesterday());
        }

        if (aux.list.isEmpty == true) loadedAll = true.obs;
        _populateList(aux.list);
      } else {
        pageCtrl = pageCtrl--;
        return loadHighscores(newPage: newPage, resetTimer: false);
      }
    } catch (e) {
      HttpErrorHandler.fallback(e);
    }

    return filterList(resetTimer: false);
  }

  void _populateList(List<HighscoresEntry> responseList) {
    for (final HighscoresEntry entry in responseList) {
      if (category.value != 'Experience gained') entry.rank = rawList.length + 1;
      if (category.value != 'Online time') entry.rank = rawList.length + 1;
      entry.world = _worldsCtrl.list.firstWhere(
        (World e) => e.name?.toLowerCase() == entry.world?.name?.toLowerCase(),
        orElse: () => World(name: entry.world?.name),
      );

      entry.supporterTitle =
          supporters.firstWhere((Supporter e) => e.name == entry.name, orElse: () => Supporter()).title;

      entry.onlineTime ??= _onlineCtrl.onlineTimes
          .firstWhere((HighscoresEntry e) => e.name == entry.name, orElse: () => HighscoresEntry())
          .onlineTime;

      rawList.add(entry);

      if ((entry.level ?? 0) < 10) rawList.remove(entry);
      if (category.value == 'Achievements' && (entry.value ?? 0) > 38) rawList.remove(entry);
    }
  }

  Future<void> filterList({bool resetTimer = true}) async {
    isLoading.value = true;

    filteredList.clear();

    if (resetTimer) _loadStartTime = DateTime.now();

    for (final HighscoresEntry item in rawList) {
      bool valid = true;

      if (hidden.contains(item.name)) valid = false;

      if (category.value == 'Experience gained' && world.value.name != 'All') {
        if (world.value.name != item.world?.name) valid = false;
      }

      if (category.value == 'Online time' && world.value.name != 'All') {
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
    if (_shouldLoadMore) return loadHighscores(newPage: true, resetTimer: false);
  }

  Future<void> getSupporters() async {
    if (supporters.isNotEmpty) return;
    isLoading.value = true;

    try {
      final dynamic response = await DatabaseClient().from('supporter').select();
      for (final dynamic e in response) {
        if (e is Map<String, dynamic>) supporters.add(Supporter.fromJson(e));
      }
    } catch (e) {
      HttpErrorHandler.fallback(e);
    }

    isLoading.value = false;
  }

  Future<void> getHidden() async {
    if (hidden.isNotEmpty) return;
    isLoading.value = true;

    try {
      final dynamic response = await DatabaseClient().from('hidden').select();
      for (final dynamic e in response) {
        if (e is Map<String, dynamic> && e['name'] is String) hidden.add(e['name'] as String);
      }
    } catch (e) {
      HttpErrorHandler.fallback(e);
    }

    isLoading.value = false;
  }
}
