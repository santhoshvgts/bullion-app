import 'package:bullion/core/models/base_model.dart';

class ProductAlert extends BaseModel {
  String? id;
  ProductOverview? productOverview;
  double? yourPrice;
  String? formattedYourPrice;
  bool? isNew;
  DateTime? postedDate;
  String? formattedPostedDate;

  ProductAlert({
     this.id,
     this.productOverview,
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
      productOverview = ProductOverview.fromJson(json['product_overview']);
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

  Pricing fromJson(json) => Pricing.fromJson(json);

  Pricing.fromJson(Map<String, dynamic> json) {
      productId  = json['product_id'];
      discountText  = json['discount_text'];
      newPrice  = json['new_price'];
  }
}
