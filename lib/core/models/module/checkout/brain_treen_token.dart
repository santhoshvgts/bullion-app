// ignore_for_file: must_be_immutable

import 'package:bullion/core/models/base_model.dart';

class BrainTreeToken extends BaseModel {
  String? token;

  BrainTreeToken({this.token});

  BrainTreeToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  @override
  BrainTreeToken fromJson(json) => BrainTreeToken.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = token;
    return data;
  }
}
