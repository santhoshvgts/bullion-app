class CompetitorPrice {
  String? competitorName;
  double? price;
  String? formattedPrice;
  String? badgeText;
  bool? isLowest;
  double? premium;
  double? spotPrice;
  bool? isLower;
  bool? inStock;

  CompetitorPrice(
      {this.competitorName,
        this.price,
        this.formattedPrice,
        this.badgeText,
        this.isLowest,
        this.premium,
        this.spotPrice,
        this.isLower,
        this.inStock});

  CompetitorPrice.fromJson(Map<String, dynamic> json) {
    competitorName = json['competitor_name'];
    price = json['price'];
    formattedPrice = json['formatted_price'];
    badgeText = json['badge_text'];
    isLowest = json['is_lowest'];
    premium = double.tryParse(json['premium'].toString());
    spotPrice = double.tryParse(json['spot_price'].toString());
    isLower = json['is_lower'];
    inStock = json['in_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['competitor_name'] = competitorName;
    data['price'] = price;
    data['formatted_price'] = formattedPrice;
    data['badge_text'] = badgeText;
    data['is_lowest'] = isLowest;
    data['premium'] = premium;
    data['spot_price'] = spotPrice;
    data['is_lower'] = isLower;
    data['in_stock'] = inStock;
    return data;
  }
}
