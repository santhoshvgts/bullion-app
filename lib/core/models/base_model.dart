import 'package:bullion/core/models/alert/alert_operators.dart';
import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/core/models/auth/forgot_password.dart';
import 'package:bullion/core/models/auth/token.dart';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/models/google/place.dart';
import 'package:bullion/core/models/google/place_autocomplete.dart';
import 'package:bullion/core/models/module/checkout/shipping_address.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/models/module/redirection.dart';
import 'package:bullion/core/models/module/search_module.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:vgts_plugin/form/base_object.dart';

import 'alert_add_response_model.dart';
import 'module/order.dart';

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

      case Order:
        return Order() as T;

      case ForgotPasswordResult:
        return ForgotPasswordResult() as T;

      case PageSettings:
        return PageSettings() as T;

      case Redirection:
        return Redirection() as T;

      case Token:
        return Token() as T;

      case SpotPrice:
        return SpotPrice() as T;

      case ModuleSettings:
        return ModuleSettings() as T;

      case SearchResult:
        return SearchResult() as T;

      case UserAddress:
        return UserAddress() as T;

      case ShippingAddress:
        return ShippingAddress() as T;

      case SelectedItemList:
        return SelectedItemList() as T;

      case PlaceAutocomplete:
        return PlaceAutocomplete() as T;

      case AddressComponents:
        return AddressComponents() as T;

      case Place:
        return Place() as T;

      case OperatorsResponse:
        return OperatorsResponse() as T;

      case AlertResponseModel:
        return AlertResponseModel() as T;

      case AlertGetResponse:
        return AlertGetResponse() as T;
    }
    throw "Requested Model not initialised in Base Model";
  }

  static createFromMap<T extends BaseModel>(Map<String, dynamic> data) {
    return object<T>().fromJson(data);
  }
}
