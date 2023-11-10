import 'package:flutter/material.dart';

class ProductTextStyle {
  static const TextStyle _titleStyle =
      TextStyle(fontWeight: FontWeight.w500, color: Color(0xff202020));
  static const TextStyle _priceStyle =
      TextStyle(fontWeight: FontWeight.w600, color: Color(0xff202020));
  static const TextStyle _strikedPriceStyle =
      TextStyle(fontWeight: FontWeight.normal, color: Color(0xff202020));
  static const TextStyle _badgeStyle =
      TextStyle(fontWeight: FontWeight.normal, color: Color(0xff202020));

  static TextStyle title(int gridCol, {Color color = const Color(0xff202020)}) {
    return _titleStyle.copyWith(fontSize: gridCol > 1 ? 14 : 18, color: color);
  }

  static TextStyle price(int gridCol, {Color color = const Color(0xff202020)}) {
    return _priceStyle.copyWith(fontSize: 16, color: color);
  }

  static TextStyle strikedPrice(int gridCol,
      {Color color = const Color(0xff202020)}) {
    return _strikedPriceStyle.copyWith(fontSize: 15, color: color);
  }

  static TextStyle badge(int gridCol, {Color color = const Color(0xff202020)}) {
    return _badgeStyle.copyWith(fontSize: 12, color: color);
  }
}
