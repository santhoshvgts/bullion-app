/// payment_method_id : 1
/// user_payment_method_id : 109
/// name : "Lingadoss Guruamy"
/// account_number : "Ending in 1111"
/// sub_text : "Expires 10/2022"
/// requires_validation : true
/// icon : "fab fa-cc-visa"
/// is_selected : false

class UserPaymentMethod {
  int? _paymentMethodId;
  int? _userPaymentMethodId;
  String? _name;
  String? _accountNumber;
  String? _subText;
  bool? _requiresValidation;
  String? _icon;
  bool? _isSelected;
  bool? _isBullionCard;

  int? get paymentMethodId => _paymentMethodId;
  int? get userPaymentMethodId => _userPaymentMethodId;
  String? get name => _name;
  String? get accountNumber => _accountNumber;
  String? get subText => _subText;
  bool? get requiresValidation => _requiresValidation;
  String? get icon => _icon;
  bool? get isSelected => _isSelected;
  bool? get isBullionCard => _isBullionCard;

  UserPaymentMethod({
      int? paymentMethodId, 
      int? userPaymentMethodId, 
      String? name, 
      String? accountNumber, 
      String? subText, 
      bool? requiresValidation, 
      String? icon, 
      bool? isSelected}){
    _paymentMethodId = paymentMethodId;
    _userPaymentMethodId = userPaymentMethodId;
    _name = name;
    _accountNumber = accountNumber;
    _subText = subText;
    _requiresValidation = requiresValidation;
    _icon = icon;
    _isSelected = isSelected;
}

  UserPaymentMethod.fromJson(dynamic json) {
    _paymentMethodId = json["payment_method_id"];
    _userPaymentMethodId = json["user_payment_method_id"];
    _name = json["name"];
    _accountNumber = json["account_number"];
    _subText = json["sub_text"];
    _requiresValidation = json["requires_validation"];
    _icon = json["icon"];
    _isSelected = json["is_selected"];
    _isBullionCard = json["is_bullion_card"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["payment_method_id"] = _paymentMethodId;
    map["user_payment_method_id"] = _userPaymentMethodId;
    map["name"] = _name;
    map["account_number"] = _accountNumber;
    map["sub_text"] = _subText;
    map["requires_validation"] = _requiresValidation;
    map["icon"] = _icon;
    map["is_selected"] = _isSelected;
    map["is_bullion_card"] = _isBullionCard;
    return map;
  }

}