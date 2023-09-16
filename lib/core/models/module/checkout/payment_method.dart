import 'package:bullion/core/models/module/checkout/user_payment_method.dart';

class PaymentMethod {
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
        this.isSelected,this.displayText,this.subText,this.userPaymentMethodId,this.requiresValidation,this.accountNumber,this.userPaymentMethods});

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
        userPaymentMethods!.add(new UserPaymentMethod.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method_id'] = this.paymentMethodId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['user_payment_method_id'] = this.userPaymentMethodId;
    data['account_number'] = this.accountNumber;
    data['sub_text'] = this.subText;
    data['requires_validation'] = this.requiresValidation;
    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['supports_user_payment_method'] = this.supportsUserPaymentMethod;
    data['has_user_payment_method'] = this.hasUserPaymentMethod;
    data['requires_zda'] = this.requiresZda;
    data['is_enabled'] = this.isEnabled;
    data['allow_manual_ach'] = this.allowManualACH;
    data['allow_plaid_ach'] = this.allowPlaidACH;
    data['is_selected'] = this.isSelected;
    data['display_text'] = this.displayText;
    if (this.userPaymentMethods != null) {
      data['user_payment_methods'] = this.userPaymentMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}