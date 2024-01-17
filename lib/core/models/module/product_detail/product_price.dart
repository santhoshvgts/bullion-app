class ProductPricesByPaymentType {
  String? name;
  String? description;
  String? formattedPrice;
  String? formattedPriceSavings;

  ProductPricesByPaymentType(
      {this.name, this.description, this.formattedPrice});

  ProductPricesByPaymentType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    formattedPrice = json['formatted_price'];
    formattedPriceSavings = json['formatted_price_savings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['description'] = description;
    data['formatted_price'] = formattedPrice;
    data['formatted_price_savings'] = formattedPriceSavings;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductPricesByPaymentType &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
