
import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/models/module/cart/shopping_cart.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/redirection.dart';

import '../market_news.dart';
import 'module_settings.dart';

class PageSettings extends BaseModel {
  int? productId;
  String? _title;
  String? _searchTerm;
  Redirection? redirection;
  String? slug;
  ProductDetails? productDetails;
  List<ModuleSettings?>? moduleSetting;
  dynamic spotPrice;
  dynamic spotPriceWithPortfolio;
  List<MarketNews>? marketNews;

  bool? isSuccess;

  bool? showHomeScreenPreference;
  bool? showFAB;

  DisplayMessage? displayMessage;
  ShoppingCart? shoppingCart;
  CartItem? addedShoppingCartItem;

  String? get title => _title == null ? "" : _title;
  String? get searchTerm => _searchTerm == null ? "" : _searchTerm;

  ModuleSettings? productListingModule;

  PageSettings();

  PageSettings.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    _title = json['title'];
    _searchTerm = json['search_term'];
    showFAB = json['show_floating_action_button'];
    showHomeScreenPreference = json['show_home_preference'];
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;

    productListingModule = json['product_listing'] != null
        ? ModuleSettings.fromJson(json['product_listing'])
        : null;
    slug = json['slug'];
    if (json['modules'] != null) {
      moduleSetting = <ModuleSettings?>[];
      json['modules'].forEach((v) {
        moduleSetting!.add(ModuleSettings.fromJson(v));
      });
    }
    spotPrice = json['spot_price'];
    spotPriceWithPortfolio = json['spot_price_with_portfolio'];

    if (json['market_news'] != null) {
      marketNews = <MarketNews>[];
      json['market_news'].forEach((v) {
        marketNews!.add(MarketNews.fromJson(v));
      });
    }

    isSuccess = json['is_success'];
    displayMessage = json['display_message'] != null
        ? DisplayMessage.fromJson(json['display_message'])
        : null;
    redirection = json['redirect_target'] != null
        ? Redirection.fromJson(json['redirect_target'])
        : null;
    shoppingCart = json['shopping_cart'] != null
        ? ShoppingCart.fromJson(json['shopping_cart'])
        : null;
    addedShoppingCartItem = json['added_shopping_cart_item'] != null
        ? CartItem.fromJson(json['added_shopping_cart_item'])
        : null;

  }

  PageSettings fromJson(json) => PageSettings.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_id'] = productId;
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }

    if (productListingModule != null) {
      data['product_listing'] = productListingModule!.toJson();
    }
    data['title'] = _title;
    data['search_term'] = _searchTerm;
    data['show_home_preference'] = showHomeScreenPreference;
    data['show_floating_action_button'] = showFAB;
    data['slug'] = slug;
    if (moduleSetting != null) {
      data['module_setting'] =
          moduleSetting!.map((v) => v!.toJson()).toList();
    }

    data['spot_price'] = spotPrice;
    data['spot_price_with_portfolio'] = spotPriceWithPortfolio;

    if (marketNews != null) {
      data['market_news'] =
          marketNews!.map((v) => v.toJson()).toList();
    }

    data['is_success'] = isSuccess;
    if (displayMessage != null) {
      data['display_message'] = displayMessage!.toJson();
    }
    if (shoppingCart != null) {
      data['shopping_cart'] = shoppingCart!.toJson();
    }
    if (redirection != null) {
      data['redirect_target'] = redirection!.toJson();
    }
    if (addedShoppingCartItem != null) {
      data['added_shopping_cart_item'] = addedShoppingCartItem!.toJson();
    }
    return data;
  }
}
