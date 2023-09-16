// import '../product_item.dart';
//
// class Overview {
//   int productId;
//   String name;
//   bool showPrice;
//   Pricing pricing;
//   int metal;
//   String metalName;
//   bool alertMe;
//   bool onSale;
//   bool onPresale;
//   String formattedPresaleDate;
//   String primaryImageUrl;
//   String imageDesc;
//   String productAction;
//   String ribbonText;
//   String ribbonTextBackgroundColor;
//   String availabilityText;
//   double avgRatings;
//   int reviewCount;
//   bool quickShip;
//   bool recurringEligible;
//
//   Overview(
//       {this.productId,
//         this.name,
//         this.showPrice,
//         this.pricing,
//         this.metal,
//         this.metalName,
//         this.alertMe,
//         this.onSale,
//         this.onPresale,
//         this.formattedPresaleDate,
//         this.primaryImageUrl,
//         this.imageDesc,
//         this.productAction,
//         this.ribbonText,
//         this.ribbonTextBackgroundColor,
//         this.availabilityText,
//         this.avgRatings,
//         this.reviewCount,
//         this.quickShip,
//         this.recurringEligible});
//
//   Overview.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     name = json['name'];
//     showPrice = json['show_price'];
//     pricing =
//     json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
//     metal = json['metal'];
//     metalName = json['metal_name'];
//     alertMe = json['alert_me'];
//     onSale = json['on_sale'];
//     onPresale = json['on_presale'];
//     formattedPresaleDate = json['formatted_presale_date'];
//     primaryImageUrl = json['primary_image_url'];
//     imageDesc = json['image_desc'];
//     productAction = json['product_action'];
//     ribbonText = json['ribbon_text'];
//     ribbonTextBackgroundColor = json['ribbon_text_background_color'];
//     availabilityText = json['availability_text'];
//     avgRatings = json['avg_ratings'];
//     reviewCount = json['review_count'];
//     quickShip = json['quick_ship'];
//     recurringEligible = json['recurring_eligible'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['name'] = this.name;
//     data['show_price'] = this.showPrice;
//     if (this.pricing != null) {
//       data['pricing'] = this.pricing.toJson();
//     }
//     data['metal'] = this.metal;
//     data['metal_name'] = this.metalName;
//     data['alert_me'] = this.alertMe;
//     data['on_sale'] = this.onSale;
//     data['on_presale'] = this.onPresale;
//     data['formatted_presale_date'] = this.formattedPresaleDate;
//     data['primary_image_url'] = this.primaryImageUrl;
//     data['image_desc'] = this.imageDesc;
//     data['product_action'] = this.productAction;
//     data['ribbon_text'] = this.ribbonText;
//     data['ribbon_text_background_color'] = this.ribbonTextBackgroundColor;
//     data['availability_text'] = this.availabilityText;
//     data['avg_ratings'] = this.avgRatings;
//     data['review_count'] = this.reviewCount;
//     data['quick_ship'] = this.quickShip;
//     data['recurring_eligible'] = this.recurringEligible;
//     return data;
//   }
// }