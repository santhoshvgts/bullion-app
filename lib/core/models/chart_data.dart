class ChartData {
  late DateTime time;
  double? price;

  ChartData({required this.time, this.price});

  ChartData.fromJson(Map<String, dynamic> json) {
    time = DateTime.fromMillisecondsSinceEpoch(json["posted_date"].toInt(), isUtc: true);
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posted_date'] = this.time;
    data['price'] = this.price;
    return data;
  }
}
