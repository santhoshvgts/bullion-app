import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/helper/utils.dart';
import 'package:flutter/material.dart';

class ActionButton {
  String? labelText;
  String? targetUrl;
  String? style;
  String? _textStyle;
  String? textColor;
  bool? hasIcon;
  String? icon;
  String? iconPosition;
  bool? openInNewWindow;

  bool get isOutline =>
      style == ActionButtonStyle.btnSecondaryOutline ||
      style == ActionButtonStyle.btnPrimaryOutline;
  bool get isSecondaryButton =>
      style == ActionButtonStyle.btnSecondaryOutline ||
      style == ActionButtonStyle.btnSecondary;

  Color get buttonColor =>
      isSecondaryButton ? AppColor.secondary : AppColor.primary;

  Color get labelTextColor =>
      getColorFromString(textColor, fallbackColor: Colors.black);

  Color get buttonTextColor => isOutline ? buttonColor : Colors.white;

  TextStyle get textStyle {
    switch (_textStyle) {
      case "mini":
        return TextStyle(
            fontSize: 12, color: buttonTextColor, fontWeight: FontWeight.w600);
      case "small":
        return TextStyle(
            fontSize: 14, color: buttonTextColor, fontWeight: FontWeight.w600);
      case "large":
        return TextStyle(
            fontSize: 20, color: buttonTextColor, fontWeight: FontWeight.w600);
      default:
        return TextStyle(
            fontSize: 15, color: buttonTextColor, fontWeight: FontWeight.w600);
    }
  }

  ActionButton(
      {this.labelText,
      this.targetUrl,
      this.style,
      this.hasIcon,
      this.icon,
      this.iconPosition,
      this.openInNewWindow});

  ActionButton.fromJson(Map<String, dynamic> json) {
    labelText = json['label_text'];
    targetUrl = json['target_url'];
    style = json['style'];
    _textStyle = json['text_style'];
    textColor = json['text_color'];
    hasIcon = json['has_icon'];
    icon = json['icon'];
    iconPosition = json['icon_position'];
    openInNewWindow = json['open_in_new_window'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label_text'] = this.labelText;
    data['target_url'] = this.targetUrl;
    data['text_style'] = this._textStyle;
    data['text_color'] = this.textColor;
    data['style'] = this.style;
    data['has_icon'] = this.hasIcon;
    data['icon'] = this.icon;
    data['icon_position'] = this.iconPosition;
    data['open_in_new_window'] = this.openInNewWindow;
    return data;
  }
}
