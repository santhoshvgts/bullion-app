/// title : "Thanks"
/// message : "Thank you for confirming your recent payment submission. You will receive a confirmation email once payment is received. "
/// sub_text : null
/// message_type : "Success"
/// message_display_type : "BottomSheet"

class PaymentAcknowledgement {
  String? _title;
  String? _message;
  dynamic _subText;
  String? _messageType;
  String? _messageDisplayType;

  String? get title => _title;
  String? get message => _message;
  dynamic get subText => _subText;
  String? get messageType => _messageType;
  String? get messageDisplayType => _messageDisplayType;

  PaymentAcknowledgement({
      String? title, 
      String? message, 
      dynamic subText, 
      String? messageType, 
      String? messageDisplayType}){
    _title = title;
    _message = message;
    _subText = subText;
    _messageType = messageType;
    _messageDisplayType = messageDisplayType;
}

  PaymentAcknowledgement.fromJson(dynamic json) {
    _title = json["title"];
    _message = json["message"];
    _subText = json["sub_text"];
    _messageType = json["message_type"];
    _messageDisplayType = json["message_display_type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["message"] = _message;
    map["sub_text"] = _subText;
    map["message_type"] = _messageType;
    map["message_display_type"] = _messageDisplayType;
    return map;
  }

}