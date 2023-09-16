import 'package:flutter/material.dart';
import 'package:bullion/helper/utils.dart';

class ProductOverview {
  int? productId;
  String? targetUrl;
  String? name;
  Pricing? pricing;
  int? metal;
  String? metalName;
  bool? alertMe;
  bool? onSale;
  bool? onPresale;
  String? presaleDate;
  String? primaryImageUrl;
  String? imageDesc;
  String? productAction;
  bool? showPrice;
  String? ribbonText;
  String? _ribbonTextBackgroundColor;
  String? priceBadgeText;
  String? availabilityText;
  double? avgRatings;
  int? reviewCount;
  bool? quickShip;
  bool? recurringEligible;

  String get formattedAvgRatings => avgRatings! > 0 ? avgRatings.toString() : "";

  Color get ribbonTextBackgroundColor =>
      getColorFromString(_ribbonTextBackgroundColor,
          fallbackColor: Colors.white);

  ProductOverview(
      {this.productId,
      this.targetUrl,
      this.name,
      this.pricing,
      this.metal,
      this.metalName,
      this.alertMe,
      this.onSale,
      this.onPresale,
      this.presaleDate,
      this.primaryImageUrl,
      this.imageDesc,
      this.productAction,
      this.showPrice,
      this.ribbonText,
      this.priceBadgeText,
      this.availabilityText,
      this.avgRatings,
      this.reviewCount,
      this.quickShip,
      this.recurringEligible});

  ProductOverview.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    targetUrl = json['target_url'];
    name = json['name'];
    pricing =
        json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    metal = json['metal'];
    metalName = json['metal_name'];
    alertMe = json['alert_me'];
    onSale = json['on_sale'];
    showPrice = json['show_price'];
    onPresale = json['on_presale'];
    presaleDate = json['presale_date'];
    primaryImageUrl = json['primary_image_url'];
    imageDesc = json['image_desc'];
    productAction = json['product_action'];
    ribbonText = json['ribbon_text'];
    _ribbonTextBackgroundColor = json['ribbon_text_background_color'];
    priceBadgeText = json['price_badge_text'];
    availabilityText = json['availability_text'];
    avgRatings = double.parse(
        json['avg_ratings'] == null ? "0" : json['avg_ratings'].toString());
    reviewCount = json['review_count'];
    quickShip = json['quick_ship'];
    recurringEligible = json['recurring_eligible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['target_url'] = this.targetUrl;
    data['name'] = this.name;
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    data['metal'] = this.metal;
    data['metal_name'] = this.metalName;
    data['alert_me'] = this.alertMe;
    data['on_sale'] = this.onSale;
    data['show_price'] = this.showPrice;
    data['on_presale'] = this.onPresale;
    data['presale_date'] = this.presaleDate;
    data['primary_image_url'] = this.primaryImageUrl;
    data['image_desc'] = this.imageDesc;
    data['product_action'] = this.productAction;
    data['ribbon_text'] = this.ribbonText;
    data['ribbon_text_background_color'] = this._ribbonTextBackgroundColor;
    data['price_badge_text'] = this.priceBadgeText;
    data['availability_text'] = this.availabilityText;
    data['avg_ratings'] = this.avgRatings;
    data['review_count'] = this.reviewCount;
    data['quick_ship'] = this.quickShip;
    data['recurring_eligible'] = this.recurringEligible;
    return data;
  }
}

class Pricing {
  int? productId;
  String? discountText;
  String? badgeText;
  double? oldPrice;
  double? newPrice;
  String? formattedOldPrice;
  String? formattedNewPrice;
  bool? strikeThroughEnabled;
  String? currency;

  Pricing(
      {this.productId,
      this.discountText,
      this.badgeText,
      this.oldPrice,
      this.newPrice,
      this.formattedOldPrice,
      this.formattedNewPrice,
      this.strikeThroughEnabled,
      this.currency});

  Pricing.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    discountText = json['discount_text'];
    badgeText = json['badge_text'];
    oldPrice = double.parse(json['old_price'].toString());
    newPrice = double.parse(json['new_price'].toString());
    formattedOldPrice = json['formatted_old_price'];
    formattedNewPrice = json['formatted_new_price'];
    strikeThroughEnabled = json['strike_through_enabled'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['discount_text'] = this.discountText;
    data['badge_text'] = this.badgeText;
    data['old_price'] = this.oldPrice;
    data['new_price'] = this.newPrice;
    data['formatted_old_price'] = this.formattedOldPrice;
    data['formatted_new_price'] = this.formattedNewPrice;
    data['strike_through_enabled'] = this.strikeThroughEnabled;
    data['currency'] = this.currency;
    return data;
  }
}
