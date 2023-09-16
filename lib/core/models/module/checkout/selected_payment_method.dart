class SelectedPaymentMethod {
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

  SelectedPaymentMethod({this.paymentMethodId,
        this.userPaymentMethodId,
        this.displayName,
        this.displaySubText,
        this.icon,
        this.isDisabled,
        this.disabledText,
        this.isSelected,
        this.notSelectedText});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method_id'] = this.paymentMethodId;
    data['user_payment_method_id'] = this.userPaymentMethodId;
    data['display_name'] = this.displayName;
    data['display_sub_text'] = this.displaySubText;
    data['icon'] = this.icon;
    data['is_disabled'] = this.isDisabled;
    data['disabled_text'] = this.disabledText;
    data['is_selected'] = this.isSelected;
    data['is_bullion_card'] = this.isBullionCard;
    data['not_selected_text'] = this.notSelectedText;
    data['selected_info_text'] = this.selectedInfoText;
    return data;
  }
}