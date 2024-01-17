import 'package:bullion/core/models/base_model.dart';

class ProductAlert extends BaseModel {
  String? id;
  ProductOverview? productOverview;
  int? requestedQuantity;
  double? yourPrice;
  String? formattedYourPrice;
  bool? isNew;
  DateTime? postedDate;
  String? formattedPostedDate;

  ProductAlert({
     this.id,
     this.productOverview,
    this.requestedQuantity,
     this.yourPrice,
     this.formattedYourPrice,
     this.isNew,
     this.postedDate,
     this.formattedPostedDate
  });

  @override
  ProductAlert fromJson(json) => ProductAlert.fromJson(json);

  ProductAlert.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      if (json['product_overview'] != null) {
        productOverview = ProductOverview.fromJson(json['product_overview']);
      }
      requestedQuantity = json['requested_qty'];
      yourPrice = json['your_price'];
      formattedYourPrice = json['formatted_your_price'];
      isNew = json['is_new'];
      postedDate = DateTime.parse(json['posted_date']);
      formattedPostedDate = json['formated_posted_date'];
  }
}

class ProductOverview {
  int? productId;
  String? targetUrl;
  String? name;
  bool? showPrice;
  Pricing? pricing;
  String? primaryImageUrl;

  ProductOverview fromJson(json) => ProductOverview.fromJson(json);

  ProductOverview({
     this.productId,
     this.targetUrl,
     this.name,
     this.showPrice,
     this.pricing,
    this.primaryImageUrl
  });

  ProductOverview.fromJson(Map<String, dynamic> json) {
      productId  = json['product_id'];
      targetUrl  = json['target_url'];
      name  = json['name'];
      showPrice  = json['show_price'];
      pricing  = Pricing.fromJson(json['pricing']);
      primaryImageUrl  = json['primary_image_url'];
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

  Pricing fromJson(json) => Pricing.fromJson(json);

  Pricing.fromJson(Map<String, dynamic> json) {
      productId  = json['product_id'];
      discountText  = json['discount_text'];
      badgeText = json['badge_text'];
      oldPrice = double.parse(json['old_price'].toString());
      newPrice  = json['new_price'];
      formattedOldPrice = json['formatted_old_price'];
      formattedNewPrice = json['formatted_new_price'];
      strikeThroughEnabled = json['strike_through_enabled'];
      currency = json['currency'];
  }
}
