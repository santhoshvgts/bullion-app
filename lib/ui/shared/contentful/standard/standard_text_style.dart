import 'package:flutter/material.dart';

class StandardTextStyle {
  static TextStyle _titleStyle = TextStyle(fontWeight: FontWeight.w600, color: Color(0xff202020));
  static TextStyle _subtitleStyle = TextStyle(fontWeight: FontWeight.normal, color: Color(0xff202020));
  static TextStyle _contentStyle = TextStyle(fontWeight: FontWeight.normal, color: Color(0xff202020));

  static TextStyle title(String type, {Color color = const Color(0xff202020)}) {
    switch (type) {
      case "mini":
        return _titleStyle.copyWith(fontSize: 12, color: color);
      case "small":
        return _titleStyle.copyWith(fontSize: 14, color: color);
      case "large":
        return _titleStyle.copyWith(fontSize: 20, color: color);
      default:
        return _titleStyle.copyWith(fontSize: 17, color: color);
    }
  }

  static TextStyle subtitle(String type, {Color color = const Color(0xff202020)}) {
    switch (type) {
      case "mini":
        return _subtitleStyle.copyWith(fontSize: 12, color: color);
      case "small":
        return _subtitleStyle.copyWith(fontSize: 14, color: color);
      case "large":
        return _subtitleStyle.copyWith(fontSize: 18, color: color);
      default:
        return _subtitleStyle.copyWith(fontSize: 16, color: color);
    }
  }

  static TextStyle content(String type, {Color color = const Color(0xff202020)}) {
    switch (type) {
      case "mini":
        return _contentStyle.copyWith(fontSize: 12, color: color);
      case "small":
        return _contentStyle.copyWith(fontSize: 14, color: color);
      case "large":
        return _contentStyle.copyWith(fontSize: 17, color: color);
      default:
        return _contentStyle.copyWith(fontSize: 15, color: color);
    }
  }
}
