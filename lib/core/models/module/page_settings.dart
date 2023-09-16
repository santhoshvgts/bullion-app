
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

  PageSettings();

  PageSettings.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    _title = json['title'];
    _searchTerm = json['search_term'];
    showFAB = json['show_floating_action_button'];
    showHomeScreenPreference = json['show_home_preference'];
    productDetails = json['product_details'] != null
        ? new ProductDetails.fromJson(json['product_details'])
        : null;
    slug = json['slug'];
    if (json['modules'] != null) {
      moduleSetting = <ModuleSettings?>[];
      json['modules'].forEach((v) {
        moduleSetting!.add(new ModuleSettings.fromJson(v));
      });
    }
    spotPrice = json['spot_price'];
    spotPriceWithPortfolio = json['spot_price_with_portfolio'];

    if (json['market_news'] != null) {
      marketNews = <MarketNews>[];
      json['market_news'].forEach((v) {
        marketNews!.add(new MarketNews.fromJson(v));
      });
    }

    isSuccess = json['is_success'];
    displayMessage = json['display_message'] != null
        ? new DisplayMessage.fromJson(json['display_message'])
        : null;
    redirection = json['redirect_target'] != null
        ? new Redirection.fromJson(json['redirect_target'])
        : null;
    shoppingCart = json['shopping_cart'] != null
        ? new ShoppingCart.fromJson(json['shopping_cart'])
        : null;
    addedShoppingCartItem = json['added_shopping_cart_item'] != null
        ? new CartItem.fromJson(json['added_shopping_cart_item'])
        : null;

  }

  PageSettings fromJson(json) => PageSettings.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails!.toJson();
    }
    data['title'] = this._title;
    data['search_term'] = this._searchTerm;
    data['show_home_preference'] = this.showHomeScreenPreference;
    data['show_floating_action_button'] = this.showFAB;
    data['slug'] = this.slug;
    if (this.moduleSetting != null) {
      data['module_setting'] =
          this.moduleSetting!.map((v) => v!.toJson()).toList();
    }

    data['spot_price'] = this.spotPrice;
    data['spot_price_with_portfolio'] = this.spotPriceWithPortfolio;

    if (this.marketNews != null) {
      data['market_news'] =
          this.marketNews!.map((v) => v.toJson()).toList();
    }

    data['is_success'] = this.isSuccess;
    if (this.displayMessage != null) {
      data['display_message'] = this.displayMessage!.toJson();
    }
    if (this.shoppingCart != null) {
      data['shopping_cart'] = this.shoppingCart!.toJson();
    }
    if (this.redirection != null) {
      data['redirect_target'] = this.redirection!.toJson();
    }
    if (this.addedShoppingCartItem != null) {
      data['added_shopping_cart_item'] = this.addedShoppingCartItem!.toJson();
    }
    return data;
  }
}
