import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forgottenland/controllers/online_controller.dart';
import 'package:forgottenland/controllers/worlds_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:forgottenland/views/widgets/src/images/svg_image.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class OnlineFilters extends StatefulWidget {
  @override
  State<OnlineFilters> createState() => _OnlineFiltersState();
}

class _OnlineFiltersState extends State<OnlineFilters> {
  final OnlineController onlineCtrl = Get.find<OnlineController>();
  final WorldsController worldsCtrl = Get.find<WorldsController>();

  Timer timer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            SizedBox(
              height: 53,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  //
                  _world(),

                  const SizedBox(width: 10),

                  _battleyeType(),

                  const SizedBox(width: 10),

                  _location(),

                  const SizedBox(width: 10),

                  _pvpType(),

                  const SizedBox(width: 10),

                  _worldType(),
                ],
              ),
            ),

            const SizedBox(height: 5),

            Container(
              height: 53,
              padding: const EdgeInsets.only(top: 5),
              child: _searchBar(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _selectedFilters(),
                const SizedBox(width: 20),
                _amount(),
              ],
            ),
          ],
        ),
      );

  Widget _dropdown<T>({
    bool enabled = true,
    required String labelText,
    T? selectedItem,
    required List<T>? itemList,
    void Function(T?)? onChanged,
    bool bigger = false,
  }) =>
      SizedBox(
        width: _dropdownWidth(bigger),
        child: CustomDropdown<T>(
          loading: onlineCtrl.isLoading.value,
          enabled: enabled,
          labelText: labelText,
          selectedItem: selectedItem,
          itemList: itemList,
          popupItemBuilder: (_, T? value, __) => _popupItemBuilder(value, enabled, selectedItem, labelText),
          onChanged: (T? value) {
            if (value == selectedItem) return;
            onChanged?.call(value);
          },
        ),
      );

  double _dropdownWidth(bool bigger) {
    final double width = MediaQuery.of(context).size.width;

    if (width < 460) return (bigger ? 1.5 : 1) * (width - 50) / 2;
    if (width < 630) return (bigger ? 1.5 : 1) * (width - 60) / 3;
    if (width < 800) return (bigger ? 1.5 : 1) * (width - 70) / 4;
    return (bigger ? 1.5 : 1) * (800 - 70) / 4;
  }

  Widget _popupItemBuilder(dynamic value, bool enabled, dynamic selectedItem, String labelText) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 25,
        ),
        child: Row(
          children: <Widget>[
            //
            _popupItemText(value, selectedItem),

            if (value is World) _worldOnlineAmount(value, selectedItem),

            Flexible(child: Container()),

            if (value is World && value.pvpType != null) _pvpTypeIcon(value),
            if (labelText.toLowerCase().contains('pvp')) _pvpTypeIcon(value),

            if (value is World && value.battleyeType != null) _battleyeTypeIcon(value),
            if (labelText.toLowerCase().contains('battleye')) _battleyeTypeIcon(value),

            if (value is World && value.location != null) _locationIcon(value.location),
            if (LIST.location.contains(value)) _locationIcon(value),
          ],
        ),
      );

  Widget _popupItemText(dynamic value, dynamic selectedItem) => Text(
        value.toString(),
        style: TextStyle(
          color: _popupItemTextColor(value, selectedItem),
        ),
      );

  Color _popupItemTextColor(dynamic value, dynamic selectedItem) {
    final dynamic a = value;
    final dynamic b = selectedItem;
    if (a is World && b is World) return a.name == b.name ? AppColors.primary : AppColors.textPrimary;
    return a == b ? AppColors.primary : AppColors.textPrimary;
  }

  Widget _worldOnlineAmount(World value, dynamic selectedItem) => Text(
        ' [${_onlineAmount(value)}]',
        style: TextStyle(
          fontSize: 14,
          color: _worldOnlineAmountTextColor(value, selectedItem),
        ),
      );

  int _onlineAmount(World world) {
    int? amount = onlineCtrl.rawList
        .where((HighscoresEntry e) => e.world?.name?.toLowerCase() == world.name?.toLowerCase())
        .toList()
        .length;
    if (world.name == 'All') amount = onlineCtrl.rawList.length;
    return amount;
  }

  Color _worldOnlineAmountTextColor(dynamic value, dynamic selectedItem) {
    final dynamic a = value;
    final dynamic b = selectedItem;
    if (a is World && b is World) return a.name == b.name ? AppColors.primary : AppColors.textSecondary;
    return a == b ? AppColors.primary : AppColors.textSecondary;
  }

  Widget _infoIcon({required Widget child, Color? backgroundColor, EdgeInsets? padding}) => Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.only(left: 4),
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: child,
      );

  Widget _pvpTypeIcon(dynamic value) {
    String image = '${value?.toString().toLowerCase().replaceAll(' ', '_')}';
    if (value is World) image = '${value.pvpType?.toLowerCase().replaceAll(' ', '_')}';
    if (image == 'all') return Container();
    return _infoIcon(child: Image.asset('assets/icons/pvp_type/$image.png'));
  }

  Widget _battleyeTypeIcon(dynamic value) {
    String image = '${value?.toString().toLowerCase().replaceAll(' ', '_')}';
    if (value is World) image = '${value.battleyeType?.toLowerCase().replaceAll(' ', '_')}';
    if (image == 'all') return Container();
    return _infoIcon(child: Image.asset('assets/icons/battleye_type/$image.png'));
  }

  Widget _locationIcon(dynamic value) {
    final Map<String, String> map = <String, String>{
      'Europe': 'EU',
      'North America': 'NA',
      'South America': 'SA',
    };
    if (value is! String) return Container();
    if (!map.containsKey(value)) return Container();
    return _infoIcon(
      backgroundColor: Colors.black87,
      padding: const EdgeInsets.all(1.5),
      child: SvgImage(asset: 'assets/icons/location/${map[value]}.svg'),
    );
  }

  Widget _searchBar() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          loading: onlineCtrl.isLoading.isTrue,
          label: 'Search',
          controller: onlineCtrl.searchController,
          onChanged: (_) {
            if (timer.isActive) timer.cancel();

            timer = Timer(
              const Duration(seconds: 1),
              () => _search(),
            );
          },
        ),
      );

  void _search() {
    dismissKeyboard(context);
    onlineCtrl.searchController.text = onlineCtrl.searchController.text.trim();
    onlineCtrl.filterList();
  }

  Widget _selectedFilters() => Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: Text(
            _selectedFiltersText,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );

  String get _selectedFiltersText {
    String? text = 'Filter: Online';

    if (onlineCtrl.world.value.name != 'All') return '$text, ${onlineCtrl.world.value}.';
    if (onlineCtrl.battleyeType.value != 'All') text = '$text, Battleye ${onlineCtrl.battleyeType.value}';
    if (onlineCtrl.location.value != 'All') text = '$text, ${onlineCtrl.location.value}';
    if (onlineCtrl.pvpType.value != 'All') text = '$text, ${onlineCtrl.pvpType.value}';
    if (onlineCtrl.worldType.value != 'All') text = '$text, ${onlineCtrl.worldType.value} World';

    return '$text.';
  }

  Widget _amount() => Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
        child: Text(
          _amountText,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      );

  String get _amountText => onlineCtrl.filteredList.isEmpty ? '' : '[${onlineCtrl.filteredList.length}]';

  Widget _world() => _dropdown<World>(
        labelText: 'World',
        selectedItem: onlineCtrl.world.value,
        itemList: _worldList,
        onChanged: (World? value) async {
          if (value is World) {
            if (value.name == 'All') {
              onlineCtrl.enableBattleyeType.value = true;
              onlineCtrl.enableLocation.value = true;
              onlineCtrl.enablePvpType.value = true;
              onlineCtrl.enableWorldType.value = true;
            } else {
              onlineCtrl.enableBattleyeType.value = false;
              onlineCtrl.enableLocation.value = false;
              onlineCtrl.enablePvpType.value = false;
              onlineCtrl.enableWorldType.value = false;
            }
            onlineCtrl.world.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  List<World> get _worldList {
    final List<World> list = List<World>.from(worldsCtrl.list);
    final List<World> removalList = <World>[];

    if (onlineCtrl.battleyeType.value != 'All') {
      for (final World world in worldsCtrl.list) {
        if (onlineCtrl.battleyeType.value != world.battleyeType) removalList.add(world);
      }
    }

    if (onlineCtrl.location.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.location != onlineCtrl.location.value) {
          removalList.add(item);
        }
      }
    }

    if (onlineCtrl.pvpType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.pvpType?.toLowerCase() != onlineCtrl.pvpType.value.toLowerCase()) {
          removalList.add(item);
        }
      }
    }

    if (onlineCtrl.worldType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.worldType?.toLowerCase() != onlineCtrl.worldType.value.toLowerCase()) {
          removalList.add(item);
        }
      }
    }

    list.sort((World a, World b) => _compareWorlds(a, b));
    list.removeWhere((World e) => e.name == 'All');
    list.insert(0, World(name: 'All'));
    removalList.removeWhere((World e) => e.name == 'All');
    return list.where((World e) => !removalList.contains(e)).toList();
  }

  int _compareWorlds(World a, World b) {
    int result = _onlineAmount(b).compareTo(_onlineAmount(a));
    if (result == 0) result = (a.name ?? '').compareTo(b.name ?? '');
    return result;
  }

  Widget _battleyeType() => _dropdown<String>(
        enabled: onlineCtrl.enableBattleyeType.value,
        labelText: 'Battleye Type',
        selectedItem: onlineCtrl.battleyeType.value,
        itemList: LIST.battleyeType,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.battleyeType.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  Widget _location() => _dropdown<String>(
        enabled: onlineCtrl.enableLocation.value,
        labelText: 'Location',
        selectedItem: onlineCtrl.location.value,
        itemList: LIST.location,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.location.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  Widget _pvpType() => _dropdown<String>(
        enabled: onlineCtrl.enablePvpType.value,
        labelText: 'Pvp Type',
        selectedItem: onlineCtrl.pvpType.value,
        itemList: LIST.pvpType,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.pvpType.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  Widget _worldType() => _dropdown<String>(
        enabled: onlineCtrl.enableWorldType.value,
        labelText: 'World Type',
        selectedItem: onlineCtrl.worldType.value,
        itemList: LIST.worldType,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.worldType.value = value;
            await onlineCtrl.filterList();
          }
        },
      );
}
