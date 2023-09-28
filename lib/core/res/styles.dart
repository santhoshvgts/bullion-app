import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/fontsize.dart';
import 'package:flutter/material.dart';

class AppStyle {
  static final ThemeData appTheme = ThemeData(
    primaryColor: AppColor.primary,
    primaryColorLight: AppColor.white,
    brightness: Brightness.light,
    dividerColor: AppColor.divider,
    indicatorColor: AppColor.primaryDark,
    iconTheme: const IconThemeData(color: AppColor.black),
    primaryIconTheme:
        const IconThemeData.fallback().copyWith(color: AppColor.primary),
    appBarTheme: const AppBarTheme().copyWith(
        color: AppColor.scaffoldBackground,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: AppTextStyle.appBarTitle,
        iconTheme: const IconThemeData().copyWith(color: AppColor.primaryDark)),
    fontFamily: "Poppins",
    scaffoldBackgroundColor: AppColor.scaffoldBackground,
  );

  static final List<BoxShadow> cardShadow = [
    const BoxShadow(color: Colors.black12, spreadRadius: 0.1, blurRadius: 2),
  ];

  static final List<BoxShadow> mildCardShadow = [
    const BoxShadow(color: Colors.black12, spreadRadius: 0.1, blurRadius: 1),
  ];

  static final List<BoxShadow> dealsShadow = [
    const BoxShadow(
        color: AppColor.shadowColor, offset: Offset(0, 5), blurRadius: 10),
  ];

  static final List<BoxShadow> topShadow = [
    const BoxShadow(
        color: Colors.black12,
        spreadRadius: 0.1,
        blurRadius: 2,
        offset: Offset(0, -2)),
  ];

  static final List<BoxShadow> chipShadow = [
    BoxShadow(
        color: AppColor.chipShadowColor,
        offset: const Offset(0, 3),
        blurRadius: 6),
  ];

  static Border divider =
      const Border(bottom: BorderSide(color: AppColor.divider, width: 0.3));

  static final Widget customDivider = const Divider(
    color: AppColor.divider,
    thickness: 0.3,
  );
}

class AppTextStyle {
  static const String fontFamily = "Poppins";

  static const TextStyle appBarTitle = TextStyle(
      fontSize: AppFontSize.xlarge,
      fontWeight: FontWeight.bold,
      color: AppColor.header,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle header = TextStyle(
      fontSize: AppFontSize.xLargest,
      fontWeight: FontWeight.w600,
      color: AppColor.header,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle subHeader = TextStyle(
      fontSize: AppFontSize.largest,
      fontWeight: FontWeight.w600,
      color: AppColor.primary,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle body = TextStyle(
      fontSize: AppFontSize.normal,
      fontWeight: FontWeight.normal,
      color: AppColor.header,
      height: 1.5,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle button = TextStyle(
      fontSize: AppFontSize.medium,
      fontWeight: FontWeight.w500,
      color: AppColor.white,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle buttonOutline = TextStyle(
      fontSize: AppFontSize.medium,
      fontWeight: FontWeight.w500,
      color: AppColor.primary,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle buttonTextSecondary = TextStyle(
      fontSize: AppFontSize.small,
      fontWeight: FontWeight.normal,
      color: AppColor.white,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle buttonSecondary = TextStyle(
      fontSize: AppFontSize.normal,
      fontWeight: FontWeight.w500,
      color: AppColor.secondary,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle dialogButtonOutline = TextStyle(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.normal,
    color: AppColor.primary,
  );

  static const TextStyle dialogButton = TextStyle(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.w600,
    color: AppColor.primary,
  );

  static const TextStyle label = TextStyle(
      fontFamily: AppTextStyle.fontFamily,
      fontSize: AppFontSize.small,
      fontWeight: FontWeight.normal,
      color: AppColor.secondaryText,
      height: 1.5);

  static const TextStyle text = TextStyle(
      fontFamily: AppTextStyle.fontFamily,
      fontSize: AppFontSize.large,
      fontWeight: FontWeight.normal,
      color: AppColor.text,
      height: 1.5);

  static const TextStyle normal = TextStyle(
      fontFamily: AppTextStyle.fontFamily,
      fontSize: AppFontSize.normal,
      fontWeight: FontWeight.w600,
      color: AppColor.primaryDark,
      height: 1.5);

  static const TextStyle largest = TextStyle(
    fontFamily: AppTextStyle.fontFamily,
    fontSize: AppFontSize.largest,
    fontWeight: FontWeight.bold,
    color: AppColor.text,
  );

  // Version 2 Text Style
  static const TextStyle title = TextStyle(
      fontFamily: AppTextStyle.fontFamily,
      fontSize: AppFontSize.dp18,
      fontWeight: FontWeight.w600,
      color: AppColor.primaryDark,
      letterSpacing: 0.15,
      height: 1.5);

  static const TextStyle subtitle = TextStyle(
      fontFamily: AppTextStyle.fontFamily,
      fontSize: AppFontSize.dp16,
      fontWeight: FontWeight.normal,
      color: AppColor.primaryDark,
      letterSpacing: 0.15,
      height: 1.5);

  static const TextStyle headerWhite = TextStyle(
      fontSize: AppFontSize.dp22,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle titleMed = TextStyle(
      fontSize: AppFontSize.dp16,
      fontWeight: FontWeight.w500,
      color: AppColor.text,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle titleMed18 = TextStyle(
      fontSize: AppFontSize.dp18,
      fontWeight: FontWeight.w500,
      color: AppColor.text,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle buttonOutlineSemi = TextStyle(
      fontSize: AppFontSize.dp12,
      fontWeight: FontWeight.w600,
      color: AppColor.primaryText,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle subTitleReg = TextStyle(
      fontSize: AppFontSize.dp14,
      fontWeight: FontWeight.w400,
      color: AppColor.text,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle privacySubTitle = TextStyle(
      fontSize: AppFontSize.dp14,
      fontWeight: FontWeight.w500,
      color: AppColor.privacySubTitle,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle privacyValue = TextStyle(
      fontSize: AppFontSize.dp14,
      fontWeight: FontWeight.w500,
      color: AppColor.secondary,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle privacySubTitleBold = TextStyle(
      fontSize: AppFontSize.dp14,
      fontWeight: FontWeight.w600,
      color: AppColor.privacySubTitle,
      fontFamily: AppTextStyle.fontFamily);

  static const TextStyle version = TextStyle(
      fontSize: AppFontSize.dp12,
      fontWeight: FontWeight.w500,
      color: AppColor.privacySubTitle,
      fontFamily: AppTextStyle.fontFamily);
}
