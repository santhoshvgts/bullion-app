import 'package:bullion/core/models/base_model.dart';

class OperatorsResponse extends BaseModel {
  List<Operator>? operators;

  OperatorsResponse();

  @override
  OperatorsResponse fromJson(json) => OperatorsResponse.fromJson(json);

  OperatorsResponse.fromJson(Map<String, dynamic> json) {
    if (json['operators'] != null) {
      operators = <Operator>[];
      json['operators'].forEach((v) {
        operators!.add(Operator.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (operators != null) {
      data['operators'] =
          operators!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Operator {
  int? id;
  String? description;

  Operator({required this.id, required this.description});

  Operator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['description'] = description;
    return data;
  }

}
