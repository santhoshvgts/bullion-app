
import 'dart:ui';

import 'package:bullion/core/res/colors.dart';
import 'package:bullion/helper/utils.dart';

class OrderTotalSummary {
  String? key;
  String? keyHelpText;
  String? value;
  String? valueTextColor;
  String? keyCode;
  bool? canRemove;


  Color get textColor => getColorFromString(valueTextColor, fallbackColor: AppColor.title);

  OrderTotalSummary(
      {this.key, this.keyHelpText, this.value, this.valueTextColor});

  OrderTotalSummary.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    keyHelpText = json['key_help_text'];
    value = json['value'];
    valueTextColor = json['value_text_color'];
    keyCode = json['key_code'];
    canRemove = json['can_remove'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['key_help_text'] = this.keyHelpText;
    data['value'] = this.value;
    data['value_text_color'] = this.valueTextColor;
    data['key_code'] = this.keyCode;
    data['can_remove'] = this.canRemove;
    return data;
  }
}
