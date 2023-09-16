import 'package:bullion/core/models/module/product_detail/product_price.dart';

class VolumePricing {
  int? productId;
  int? minQty;
  int? maxQty;
  bool? strikeThroughEnabled;
  String? tier;
  List<ProductPricesByPaymentType>? productPricesByPaymentType;

  VolumePricing(
      {this.productId,
        this.minQty,
        this.maxQty,
        this.strikeThroughEnabled,
        this.tier,
        this.productPricesByPaymentType});

  VolumePricing.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    minQty = json['min_qty'];
    maxQty = json['max_qty'];
    strikeThroughEnabled = json['strike_through_enabled'];
    tier = json['tier'];
    if (json['product_prices_by_payment_type'] != null) {
      productPricesByPaymentType = <ProductPricesByPaymentType>[];
      json['product_prices_by_payment_type'].forEach((v) {
        productPricesByPaymentType!
            .add(new ProductPricesByPaymentType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['min_qty'] = this.minQty;
    data['max_qty'] = this.maxQty;
    data['strike_through_enabled'] = this.strikeThroughEnabled;
    data['tier'] = this.tier;
    if (this.productPricesByPaymentType != null) {
      data['product_prices_by_payment_type'] =
          this.productPricesByPaymentType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}