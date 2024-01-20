import 'package:bullion/core/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:bullion/helper/utils.dart';

class ProductOverview extends BaseModel {
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

  int? onHand;
  int? orderMin;
  int? dealMax;

  bool? quickShip;
  bool? recurringEligible;


  bool get showDealProgress {
    return (dealMax ?? 0) > 0;
  }

  double get soldPercentage {
    int dealMaxValue = dealMax ?? 0;
    int onHandValue = onHand ?? 0;
    int soldQty = 0;
    if (dealMaxValue <= 0) {
      return 0;
    }

    if (dealMaxValue < onHandValue) {
      onHandValue = dealMaxValue;
    }

    soldQty = dealMaxValue - onHandValue;

    // print("onHand: ${onHandValue}");
    // print("dealMax: ${dealMaxValue}");
    // print("(onHand ?? 0) / (dealMax ?? 0); ${(soldQty/ dealMaxValue)}");
    return (soldQty/ dealMaxValue);
  }


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

  ProductOverview fromJson(Map<String, dynamic> json) => ProductOverview.fromJson(json);

  ProductOverview.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    targetUrl = json['target_url'];
    name = json['name'];
    pricing =
        json['pricing'] != null ? Pricing.fromJson(json['pricing']) : null;
    metal = json['metal'];
    metalName = json['metal_name'];
    alertMe = json['alert_me'];
    onSale = json['on_sale'];
    showPrice = json['show_price'];
    onPresale = json['on_presale'];
    presaleDate = json['presale_date'];

    onHand = json['on_hand'];
    orderMin = json['order_min'];
    dealMax = json['deal_max'];

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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_id'] = productId;
    data['target_url'] = targetUrl;
    data['name'] = name;
    if (pricing != null) {
      data['pricing'] = pricing!.toJson();
    }
    data['metal'] = metal;
    data['metal_name'] = metalName;
    data['alert_me'] = alertMe;
    data['on_sale'] = onSale;

    data['on_hand'] = onHand;
    data['deal_max'] = dealMax;
    data['order_min'] = orderMin;


    data['show_price'] = showPrice;
    data['on_presale'] = onPresale;
    data['presale_date'] = presaleDate;
    data['primary_image_url'] = primaryImageUrl;
    data['image_desc'] = imageDesc;
    data['product_action'] = productAction;
    data['ribbon_text'] = ribbonText;
    data['ribbon_text_background_color'] = _ribbonTextBackgroundColor;
    data['price_badge_text'] = priceBadgeText;
    data['availability_text'] = availabilityText;
    data['avg_ratings'] = avgRatings;
    data['review_count'] = reviewCount;
    data['quick_ship'] = quickShip;
    data['recurring_eligible'] = recurringEligible;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_id'] = productId;
    data['discount_text'] = discountText;
    data['badge_text'] = badgeText;
    data['old_price'] = oldPrice;
    data['new_price'] = newPrice;
    data['formatted_old_price'] = formattedOldPrice;
    data['formatted_new_price'] = formattedNewPrice;
    data['strike_through_enabled'] = strikeThroughEnabled;
    data['currency'] = currency;
    return data;
  }
}
