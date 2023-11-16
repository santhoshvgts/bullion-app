import 'package:bullion/core/models/base_model.dart';

class AlertResponseModel extends BaseModel {
  int? id;
  int? operatorId;
  int? metal;
  double? price;
  String? operatorName;
  String? description;
  String? formattedPrice;
  bool? active;
  DateTime? postedDate;
  DateTime? triggeredDate;
  bool? triggered;
  String? formattedPostedDate;
  String? formattedTriggeredDate;

  AlertResponseModel(
      {this.id,
      this.operatorId,
      this.metal,
      this.price,
      this.operatorName,
      this.description,
      this.formattedPrice,
      this.active,
      this.postedDate,
      this.triggeredDate,
      this.triggered,
      this.formattedPostedDate,
      this.formattedTriggeredDate});

  @override
  AlertResponseModel fromJson(json) => AlertResponseModel.fromJson(json);

  AlertResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operatorId = json['operator_id'];
    metal = json['metal'];
    price = json['price'].toDouble();
    operatorName = json['operator_name'];
    description = json['description'];
    formattedPrice = json['formatted_price'];
    active = json['active'];
    postedDate = DateTime.parse(json['posted_date']);
    triggeredDate = json['triggered_date'] != null
        ? DateTime.parse(json['triggered_date'])
        : null;
    triggered = json['triggered'];
    formattedPostedDate = json['formatted_posted_date'];
    formattedTriggeredDate = json['formatted_triggered_date'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}
