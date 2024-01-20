import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/product_item.dart';

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
