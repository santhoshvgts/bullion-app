import 'package:bullion/core/models/auth/token.dart';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/models/base_model.dart';

class AuthResponse extends BaseModel {
  Token? token;
  User? user;
  String? message;
  bool? isLockedOut;
  bool? isNotAllowed;
  bool? success;

  AuthResponse({this.token, this.user, this.message, this.isLockedOut, this.isNotAllowed, this.success});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
    isLockedOut = json['is_locked_out'];
    isNotAllowed = json['is_not_allowed'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.token != null) {
      data['token'] = this.token!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    data['is_locked_out'] = this.isLockedOut;
    data['is_not_allowed'] = this.isNotAllowed;
    data['success'] = this.success;
    return data;
  }
}
