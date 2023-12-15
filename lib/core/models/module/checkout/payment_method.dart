import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/checkout/user_payment_method.dart';

// ignore: must_be_immutable
class PaymentMethod extends BaseModel {
  int? paymentMethodId;
  String? name;
  String? icon;
  String? description;
  String? shortDescription;
  bool? supportsUserPaymentMethod;
  bool? hasUserPaymentMethod;
  bool? requiresZda;
  bool? isEnabled;
  bool? isSelected;
  bool? allowManualACH;
  bool? allowPlaidACH;
  List<UserPaymentMethod>? userPaymentMethods;
  String? displayText;
  int? userPaymentMethodId;
  String? accountNumber;
  String? subText;
  bool? requiresValidation;

  PaymentMethod(
      {this.paymentMethodId,
      this.name,
      this.icon,
      this.description,
      this.shortDescription,
      this.supportsUserPaymentMethod,
      this.hasUserPaymentMethod,
      this.requiresZda,
      this.allowManualACH,
      this.allowPlaidACH,
      this.isEnabled,
      this.isSelected,
      this.displayText,
      this.subText,
      this.userPaymentMethodId,
      this.requiresValidation,
      this.accountNumber,
      this.userPaymentMethods});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    paymentMethodId = json['payment_method_id'];
    name = json['name'];
    icon = json['icon'];
    userPaymentMethodId = json['user_payment_method_id'];
    accountNumber = json['account_number'];
    subText = json['sub_text'];
    requiresValidation = json['requires_validation'];
    description = json['description'];
    shortDescription = json['short_description'];
    supportsUserPaymentMethod = json['supports_user_payment_method'];
    hasUserPaymentMethod = json['has_user_payment_method'];
    requiresZda = json['requires_zda'];
    isEnabled = json['is_enabled'];
    allowManualACH = json['allow_manual_ach'];
    allowPlaidACH = json['allow_plaid_ach'];
    displayText = json['display_text'];

    isSelected = json['is_selected'];
    if (json['user_payment_methods'] != null) {
      userPaymentMethods = <UserPaymentMethod>[];
      json['user_payment_methods'].forEach((v) {
        userPaymentMethods!.add(UserPaymentMethod.fromJson(v));
      });
    }
  }
  @override
  PaymentMethod fromJson(json) => PaymentMethod.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_method_id'] = paymentMethodId;
    data['name'] = name;
    data['icon'] = icon;
    data['user_payment_method_id'] = userPaymentMethodId;
    data['account_number'] = accountNumber;
    data['sub_text'] = subText;
    data['requires_validation'] = requiresValidation;
    data['description'] = description;
    data['short_description'] = shortDescription;
    data['supports_user_payment_method'] = supportsUserPaymentMethod;
    data['has_user_payment_method'] = hasUserPaymentMethod;
    data['requires_zda'] = requiresZda;
    data['is_enabled'] = isEnabled;
    data['allow_manual_ach'] = allowManualACH;
    data['allow_plaid_ach'] = allowPlaidACH;
    data['is_selected'] = isSelected;
    data['display_text'] = displayText;
    if (userPaymentMethods != null) {
      data['user_payment_methods'] = userPaymentMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
