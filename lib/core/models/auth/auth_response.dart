// ignore_for_file: must_be_immutable

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

   @override
     AuthResponse fromJson(json) => AuthResponse.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (token != null) {
      data['token'] = token!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['message'] = message;
    data['is_locked_out'] = isLockedOut;
    data['is_not_allowed'] = isNotAllowed;
    data['success'] = success;
    return data;
  }
}
