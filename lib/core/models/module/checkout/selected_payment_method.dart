// ignore_for_file: must_be_immutable

import 'package:bullion/core/models/base_model.dart';

class SelectedPaymentMethod extends BaseModel {
  int? paymentMethodId;
  int? userPaymentMethodId;
  String? displayName;
  String? displaySubText;
  String? icon;
  bool? isDisabled;
  String? disabledText;
  bool? isSelected;
  bool? isBullionCard;
  String? notSelectedText;
  String? selectedInfoText;

  SelectedPaymentMethod({this.paymentMethodId, this.userPaymentMethodId, this.displayName, this.displaySubText, this.icon, this.isDisabled, this.disabledText, this.isSelected, this.notSelectedText});

  SelectedPaymentMethod.fromJson(Map<String, dynamic> json) {
    paymentMethodId = json['payment_method_id'];
    userPaymentMethodId = json['user_payment_method_id'];
    displayName = json['display_name'];
    displaySubText = json['display_sub_text'];
    icon = json['icon'];
    isDisabled = json['is_disabled'];
    disabledText = json['disabled_text'];
    isSelected = json['is_selected'];
    isBullionCard = json['is_bullion_card'];
    notSelectedText = json['not_selected_text'];
    selectedInfoText = json['selected_info_text'];
  }

  @override
  SelectedPaymentMethod fromJson(json) => SelectedPaymentMethod.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_method_id'] = paymentMethodId;
    data['user_payment_method_id'] = userPaymentMethodId;
    data['display_name'] = displayName;
    data['display_sub_text'] = displaySubText;
    data['icon'] = icon;
    data['is_disabled'] = isDisabled;
    data['disabled_text'] = disabledText;
    data['is_selected'] = isSelected;
    data['is_bullion_card'] = isBullionCard;
    data['not_selected_text'] = notSelectedText;
    data['selected_info_text'] = selectedInfoText;
    return data;
  }
}
