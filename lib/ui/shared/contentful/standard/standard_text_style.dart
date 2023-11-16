import 'package:bullion/core/res/styles.dart';
import 'package:flutter/material.dart';

class StandardTextStyle {
  static TextStyle title(String type, {Color color = const Color(0xff202020)}) {
    switch (type) {
      case "mini":
        return AppTextStyle.labelMedium.copyWith(color: color);
      case "small":
        return AppTextStyle.titleSmall.copyWith(color: color);
      case "large":
        return AppTextStyle.titleLarge.copyWith(color: color);
      default:
        return AppTextStyle.titleMedium.copyWith(color: color);
    }
  }

  static TextStyle subtitle(
    String type, {
    Color color = const Color(0xff202020),
  }) {
    switch (type) {
      case "mini":
        return AppTextStyle.labelMedium.copyWith(color: color);
      case "small":
        return AppTextStyle.labelLarge.copyWith(color: color);
      case "large":
        return AppTextStyle.titleMedium.copyWith(color: color);
      default:
        return AppTextStyle.labelLarge.copyWith(color: color);
    }
  }

  static TextStyle content(
    String type, {
    Color color = const Color(0xff202020),
  }) {
    switch (type) {
      case "mini":
        return AppTextStyle.bodySmall.copyWith(color: color);
      case "small":
        return AppTextStyle.bodyMedium.copyWith(color: color);
      case "large":
        return AppTextStyle.bodyLarge.copyWith(color: color);
      default:
        return AppTextStyle.bodyMedium.copyWith(color: color);
    }
  }
}
