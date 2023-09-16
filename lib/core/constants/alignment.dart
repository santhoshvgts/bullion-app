import 'package:flutter/material.dart';
import 'package:bullion/core/constants/image_shape.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/fontsize.dart';

class UIAlignment {
  static TextAlign textAlign(String type) {
    switch (type) {
      case "center":
        return TextAlign.center;

      case "right":
        return TextAlign.right;

      case "left":
      default:
        return TextAlign.left;
    }
  }

  static Alignment alignment(String type) {
    switch (type) {
      case "center":
        return Alignment.center;

      case "right":
        return Alignment.centerRight;

      case "top":
      case "left-top":
        return Alignment.topLeft;

      case "bottom":
      case "left-bottom":
        return Alignment.bottomLeft;

      case "top-right":
      case "right-top":
        return Alignment.topRight;

      case "bottom-right":
      case "right-bottom":
        return Alignment.bottomRight;

      case "left":
      default:
        return Alignment.centerLeft;
    }
  }

  static WrapAlignment wrapAlignment(String type) {
    print(type);

    switch (type) {
      case "center":
        return WrapAlignment.center;

      case "right":
        return WrapAlignment.end;

      case "left":
        return WrapAlignment.start;

      default:
        return WrapAlignment.center;
    }
  }

  static BorderRadius imageShapeRadius(String shape) {
    switch (shape) {
      case ImageShape.round:
        return BorderRadius.circular(100);
      case ImageShape.standard:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(0);
    }
  }

  static TextStyle titleTextStyle(int gridColumn) {
    if (gridColumn == 1) {
      return const TextStyle(
          fontSize: AppFontSize.dp16,
          fontWeight: FontWeight.w600,
          color: AppColor.primaryDark,
          letterSpacing: 0.15,
          height: 1.5);
    }
    return const TextStyle(
        fontSize: AppFontSize.dp14,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryDark,
        letterSpacing: 0.15,
        height: 1.5);
  }

  static TextStyle badgeTextStyle(int gridColumn) {
    if (gridColumn == 1) {
      return const TextStyle(
          fontSize: AppFontSize.dp14,
          fontWeight: FontWeight.normal,
          color: AppColor.header,
          height: 1.5);
    }
    return const TextStyle(
        fontSize: AppFontSize.dp12,
        fontWeight: FontWeight.normal,
        color: AppColor.header,
        letterSpacing: 0.15,
        height: 1.5);
  }
}
