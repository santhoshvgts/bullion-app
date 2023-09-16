
import 'package:bullion/core/models/base_model.dart';

class ForgotPasswordResult extends BaseModel {
  String? message;
  String? email;
  String? passkey;
  bool? success;

  ForgotPasswordResult({this.message, this.success});

  ForgotPasswordResult.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    passkey = json['key'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['key'] = this.passkey;
    data['email'] = this.email;
    return data;
  }
}