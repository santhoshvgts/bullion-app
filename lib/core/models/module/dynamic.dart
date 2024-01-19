
import 'package:bullion/core/models/base_model.dart';

class DynamicModel extends BaseModel {

  dynamic json;

  DynamicModel();

  DynamicModel.fromJson(Map<String, dynamic> this.json);

  @override
  DynamicModel fromJson(json) => DynamicModel.fromJson(json);

}