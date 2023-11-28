import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/display_settings.dart';
import 'package:bullion/core/models/module/item_display_settings.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProductViewModel extends BaseViewModel {
  final NavigationService? navigationService = locator<NavigationService>();

  ModuleSettings? settings;

  DisplaySettings? get displaySetting => settings!.displaySettings;

  ProductModel? _productListModule;

  ProductModel? get productListModule => _productListModule;

  List<ProductOverview>? _items;

  ItemDisplaySettings get itemDisplaySettings =>
      settings!.displaySettings!.itemDisplaySettings;

  List<ProductOverview>? get items => _items;

  double get spacing => 10;
  double get runSpacing => 10;

  double itemWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width.floorToDouble();

    double totalSpacing = spacing * (itemDisplaySettings.gridCols - 1);
    double wrapSpacing =  12;

    double _itemWidth = (screenWidth -
            (itemDisplaySettings.fullBleed
                ? 0
                : (totalSpacing + wrapSpacing))) /
        itemDisplaySettings.gridCols;
    double bleedSpacing =
        itemDisplaySettings.fullBleed ? 0 : (_itemWidth / 100) * 6;

    _itemWidth =
        itemDisplaySettings.wrapItems ? _itemWidth : _itemWidth - bleedSpacing;
    return _itemWidth;
  }

  onItemTap(ProductOverview item) {
    notifyListeners();
    navigationService!
        .pushNamed(item.targetUrl, arguments: ProductDetails(overview: item));
  }

  init(ModuleSettings? settings) {
    this.settings = settings;
    if (settings?.moduleType == ModuleType.productList) {
      _productListModule = ProductModel.fromJson(settings?.productModel);
      _items = _productListModule!.products;
    } else {
      _items = (settings?.productModel as List?)
              ?.map((e) => ProductOverview.fromJson(e))
              .toList() ??
          [];
    }
    notifyListeners();
  }

  onDataChange(ModuleSettings? settings) {
    init(settings);
  }

  //
  // Future<ProductModel> paginate(String url) async {
  //   setBusy(true);
  //   notifyListeners();
  //
  //   print("PAGINATE");
  //
  //   ModuleSettings data = await categoryApi.paginateProducts(url);
  //   this._productListModule = ProductModel.fromJson(data.productModel);
  //   this._items = _productListModule.products;
  //
  //   setBusy(false);
  //   notifyListeners();
  //
  //   return _productListModule;
  // }
  //
  // Future<ProductModel> filter(String url) async {
  //   setBusy(true);
  //   notifyListeners();
  //
  //   ModuleSettings data = await categoryApi.filterProducts(url);
  //   this._productListModule = ProductModel.fromJson(data.productModel);
  //   this._items = _productListModule.products;
  //
  //   print("NEXT PAGE URL ${_productListModule.nextPageUrl}");
  //   print(_productListModule.products.length);
  //
  //
  //   setBusy(false);
  //   notifyListeners();
  //
  //   return _productListModule;
  // }
}
