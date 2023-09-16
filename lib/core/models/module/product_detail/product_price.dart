class ProductPricesByPaymentType {
  String? name;
  String? description;
  String? formattedPrice;

  ProductPricesByPaymentType(
      {this.name, this.description, this.formattedPrice});

  ProductPricesByPaymentType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    formattedPrice = json['formatted_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['formatted_price'] = this.formattedPrice;
    return data;
  }
}