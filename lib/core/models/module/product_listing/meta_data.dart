class MetaData {
  String? saleStartDate;
  String? saleEndDate;

  MetaData({this.saleStartDate, this.saleEndDate});

  MetaData.fromJson(Map<String, dynamic> json) {
    saleStartDate = json['sale_start_date'];
    saleEndDate = json['sale_end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sale_start_date'] = this.saleStartDate;
    data['sale_end_date'] = this.saleEndDate;
    return data;
  }
}