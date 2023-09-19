import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/item_display_settings.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/standard_item.dart';

class StandardViewModel extends VGTSBaseViewModel {
  late ModuleSettings settings;

  List<StandardItem>? _items;

  int get moreCategoriesLength => itemDisplaySettings.collpasable && _items!.length > 8 ? _items!.length - 8 : 0;

  bool isCollPaSable = false;

  ItemDisplaySettings get itemDisplaySettings => settings.displaySettings!.itemDisplaySettings;

  List<StandardItem>? get items => itemDisplaySettings.collpasable && !isCollPaSable && _items!.length > 8 ? _items!.getRange(0, 8).toList() : _items;

  // Horizontal Space: Right & Left Space
  double get spacing => 10; //itemDisplaySettings.cardPadding;

  // Vertical Space: Top & Bottom Space
  double get runSpacing => itemDisplaySettings.fullBleed ? 0 : 10; //itemDisplaySettings.cardPadding;

  double itemWidth(BuildContext context) {
    // Get Screen Width and Round the Value to double
    double screenWidth = MediaQuery.of(context).size.width.floorToDouble();

    double totalSpacing = 0;
    if (!itemDisplaySettings.fullBleed) {
      totalSpacing = spacing * (itemDisplaySettings.gridCols - 1);
      double wrap = spacing * 2;
      totalSpacing = totalSpacing + wrap;
    }

    // Calculating itemWidth by dividing total grid columns
    double _itemWidth = (screenWidth - totalSpacing) / itemDisplaySettings.gridCols;

    // Additional space for showing next available card if wrap_items = false
    //TODO -- Change parameter for understanding
    double bleedSpacing = itemDisplaySettings.fullBleed ? 0 : _itemWidth / 100 * (itemDisplaySettings.gridCols == 1 ? 12 : 6);

    // Reduce bleedSpacing when wrap_items = true
    _itemWidth = itemDisplaySettings.wrapItems ? _itemWidth : _itemWidth - bleedSpacing;

    return _itemWidth;
  }

  @required
  init(ModuleSettings settings) {
    this.settings = settings;
    this._items = settings.items!.map((e) => StandardItem.fromJson(e)).toList();
    notifyListeners();
  }

  onChange() {
    isCollPaSable = !isCollPaSable;
    notifyListeners();
  }

  onItemTap(String? url) {
    navigationService!.pushNamed(url, rootNavigator: true);
  }
}
