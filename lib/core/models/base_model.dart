import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/core/models/auth/forgot_password.dart';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/models/module/redirection.dart';
import 'package:vgts_plugin/form/base_object.dart';

class BaseModel extends BaseObject {
  BaseModel();

  BaseModel fromJson(Map<String, dynamic> json) {
    throw ("fromJson not implemented");
  }

  Map<String, dynamic> toJson() {
    throw ("toJson not implemented");
  }

  Map<String, dynamic> toRequestParam() {
    throw ("toRequestParam not implemented. Please check the modal object");
  }

  Object get key {
    throw ("Get Key not defined");
  }

  String get textIdentifier {
    return runtimeType.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is BaseModel) {
      return textIdentifier == other.textIdentifier;
    }
    return false;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static T object<T extends BaseModel>() {
    switch (T) {
      case AuthResponse:
        return AuthResponse() as T;

      case User:
        return User() as T;

      case ForgotPasswordResult:
        return ForgotPasswordResult() as T;

      case PageSettings:
        return PageSettings() as T;

      case Redirection:
        return Redirection() as T;
    }
    throw "Requested Model not initialised in Base Model";
  }

  static createFromMap<T extends BaseModel>(Map<String, dynamic> data) {
    return object<T>().fromJson(data);
  }
}
