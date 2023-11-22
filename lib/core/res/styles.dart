import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/fontsize.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppStyle {
  static final ThemeData appTheme = ThemeData(
    useMaterial3: true,
    primaryColorLight: AppColor.white,
    brightness: Brightness.light,
    dividerColor: AppColor.divider,
    indicatorColor: AppColor.primaryDark,
    colorSchemeSeed: AppColor.primary,
    iconTheme: const IconThemeData(color: AppColor.black),
    primaryIconTheme: const IconThemeData.fallback().copyWith(
      color: AppColor.primary,
    ),
    appBarTheme: const AppBarTheme().copyWith(
      color: AppColor.scaffoldBackground,
      elevation: 0.5,
      scrolledUnderElevation: 1,
      centerTitle: true,
      titleTextStyle: AppTextStyle.titleLarge,
      surfaceTintColor: AppColor.white,
      shadowColor: AppColor.shadowColor,
      iconTheme: const IconThemeData().copyWith(color: AppColor.primaryDark),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    fontFamily: "Poppins",
    scaffoldBackgroundColor: AppColor.scaffoldBackground,
  );

  static final List<BoxShadow> cardShadow = [
    const BoxShadow(color: Colors.black12, spreadRadius: 0.1, blurRadius: 2),
  ];

  static final List<BoxShadow> mildCardShadow = [
    const BoxShadow(color: Colors.black12, spreadRadius: 0.1, blurRadius: 1),
  ];

  static final List<BoxShadow> elevatedCardShadow = [
    const BoxShadow(
        color: Colors.black12, offset: Offset(0, 2), blurRadius: 10),
  ];

  // static final List<BoxShadow> dealsShadow = [
  //   const BoxShadow(
  //       color: AppColor.shadowColor, offset: Offset(0, 5), blurRadius: 10),
  // ];

  static final List<BoxShadow> topShadow = [
    const BoxShadow(
        color: Colors.black12,
        spreadRadius: 0.1,
        blurRadius: 2,
        offset: Offset(0, -1)),
  ];

  static final List<BoxShadow> chipShadow = [
    BoxShadow(
        color: AppColor.chipShadowColor,
        offset: const Offset(0, 3),
        blurRadius: 6),
  ];

  static Border divider =
      const Border(bottom: BorderSide(color: AppColor.divider, width: 0.3));

  static const Widget customDivider = Divider(
    color: AppColor.divider,
    thickness: 0.3,
  );

  static const Widget dottedDivider = DottedLine(
    dashGapLength: 2,
    dashLength: 3,
    lineThickness: 0.5,
    dashColor: AppColor.outline,
  );
}

class AppTextStyle {
  static const String fontFamily = "Poppins";

  // titleLarge
  // static const TextStyle appBarTitle = TextStyle(
  //     fontSize: AppFontSize.xlarge,
  //     fontWeight: FontWeight.bold,
  //     color: AppColor.header,
  //     fontFamily: AppTextStyle.fontFamily);

  // headlineSmall
  // static const TextStyle header = TextStyle(
  //     fontSize: AppFontSize.xLargest,
  //     fontWeight: FontWeight.w600,
  //     color: AppColor.header,
  //     fontFamily: AppTextStyle.fontFamily);

  // titleMedium
  // static const TextStyle subHeader = TextStyle(
  //     fontSize: AppFontSize.medium,
  //     fontWeight: FontWeight.w600,
  //     color: AppColor.primary,
  //     fontFamily: AppTextStyle.fontFamily);

  // bodyMedium
  // static const TextStyle body = TextStyle(
  //     fontSize: AppFontSize.normal,
  //     fontWeight: FontWeight.normal,
  //     color: AppColor.header,
  //     height: 1.5,
  //     fontFamily: AppTextStyle.fontFamily);

  // titleSmall
  // static const TextStyle button = TextStyle(
  //     fontSize: AppFontSize.medium,
  //     fontWeight: FontWeight.w500,
  //     color: AppColor.white,
  //     fontFamily: AppTextStyle.fontFamily);

  // titleSmall
  // static const TextStyle buttonOutline = TextStyle(
  //     fontSize: AppFontSize.medium,
  //     fontWeight: FontWeight.w500,
  //     color: AppColor.primary,
  //     fontFamily: AppTextStyle.fontFamily);

  // titleSmall
  // static const TextStyle buttonTextSecondary = TextStyle(
  //     fontSize: AppFontSize.small,
  //     fontWeight: FontWeight.normal,
  //     color: AppColor.white,
  //     fontFamily: AppTextStyle.fontFamily);

  // titleSmall
  // static const TextStyle buttonSecondary = TextStyle(
  //     fontSize: AppFontSize.normal,
  //     fontWeight: FontWeight.w500,
  //     color: AppColor.secondary,
  //     fontFamily: AppTextStyle.fontFamily);

  // labelMedium
  // static const TextStyle dialogButtonOutline = TextStyle(
  //   fontSize: AppFontSize.small,
  //   fontWeight: FontWeight.normal,
  //   color: AppColor.primary,
  // );

  // labelMedium
  // static const TextStyle dialogButton = TextStyle(
  //   fontSize: AppFontSize.small,
  //   fontWeight: FontWeight.w600,
  //   color: AppColor.primary,
  // );

  // labelMedium
  // static const TextStyle label = TextStyle(
  //     fontFamily: AppTextStyle.fontFamily,
  //     fontSize: AppFontSize.small,
  //     fontWeight: FontWeight.normal,
  //     color: AppColor.secondaryText,
  //     height: 1.5);

  // labelMedium
  // static const TextStyle text = TextStyle(
  //     fontFamily: AppTextStyle.fontFamily,
  //     fontSize: AppFontSize.large,
  //     fontWeight: FontWeight.normal,
  //     color: AppColor.text,
  //     height: 1.5);

  // bodyMedium
  // static const TextStyle normal = TextStyle(
  //     fontFamily: AppTextStyle.fontFamily,
  //     fontSize: AppFontSize.normal,
  //     fontWeight: FontWeight.w600,
  //     color: AppColor.primaryDark,
  //     height: 1.5);

  // titleLarge
  // static const TextStyle largest = TextStyle(
  //   fontFamily: AppTextStyle.fontFamily,
  //   fontSize: AppFontSize.largest,
  //   fontWeight: FontWeight.bold,
  //   color: AppColor.text,
  // );

  // Version 2 Text Style
  // titleLarge
  // static const TextStyle title = TextStyle(
  //     fontFamily: AppTextStyle.fontFamily,
  //     fontSize: AppFontSize.dp18,
  //     fontWeight: FontWeight.w600,
  //     color: AppColor.primaryDark,
  //     letterSpacing: 0.15,
  //     height: 1.5);

  // titleMedium
  // static const TextStyle subtitle = TextStyle(
  //     fontFamily: AppTextStyle.fontFamily,
  //     fontSize: AppFontSize.dp16,
  //     fontWeight: FontWeight.normal,
  //     color: AppColor.primaryDark,
  //     letterSpacing: 0.15,
  //     height: 1.5);

  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 52 / 45,
    letterSpacing: 0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: 0,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 40 / 32,
    letterSpacing: 0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 36 / 28,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 28 / 22,
    letterSpacing: 0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: AppFontSize.dp16,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: AppFontSize.dp14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.11,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: AppFontSize.dp14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: AppFontSize.dp12,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppFontSize.dp16,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppFontSize.dp14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AppFontSize.dp12,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
  );
}
