import 'package:flutter/material.dart';

class AppColor {
  static const Color primary = Color(0xFF006936);
  static Color primary60 = const Color(0xFF006936).withOpacity(0.6);

  static const Color indicatorColor = Color(0xFFB8F5D4);
  static const Color primaryDark = Color(0xFF002539);
  static const Color secondary = Color(0xFF006936);
  static const Color accent = Color(0xFF000000);
  static const Color divider = Color(0x2B495A14);
  static const Color border = Color(0xffDADADA);

  static const Color error = Color(0xFFB3261E);

  static const Color text = Color(0xFF14203C);
  static const Color introText = Color(0xFF013b53);
  static const Color greenText = Color(0xFF006214);

  static const Color secondaryText = Color(0xFF666666);
  static const Color header = Color(0xFF002539);
  static const Color headerBlack = Color(0xFF202020);
  static const Color secondaryHeader = Color(0xFF2B495A);
  static const Color title = Color(0xFF2B495A);
  static const Color primaryText = Color(0xFF626A7D);

  static const Color background = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF4F5F7);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black85 = Color(0xD9000000);

  static const Color gold = Color(0xFFFFB800); //F5B32A
  static const Color silver = Color(0xFF797979);
  static const Color platinum = Color(0xFFFD5567);
  static const Color palladium = Color(0xFF6636BE);

  static const Color secondaryGold = Color(0xFFECB43D); //F5B32A
  static const Color secondarySilver = Color(0xFF797979);
  static const Color secondaryPlatinum = Color(0xFFD86F76);
  static const Color secondaryPalladium = Color(0xFF6E50B2);

  static const Color shadowColor = Color(0xFFE3E3E3);
  static Color chipShadowColor = const Color(0xFF808080).withOpacity(0.5);

  static Color disabled = const Color(0xFF808080);

  static const Color green = Color(0xFF0F8110);
  static const Color red = Color(0xFFCD3737);
  static const Color offerText = Color(0xFF24A186);
  static const Color orange = Color(0xFFf98d29);
  static const Color blue = Color(0xFF005f9b);

  static const Color dealsRed = Color(0xFFC30000);
  static const Color black20 = Color(0xFF344456);

  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineBorder = Color(0xFFC1C2B8);

  static const Color bullion = Color(0xff001A29);
  static const Color bullionBg = Color(0xffFFFDF2);
  static const Color bullionProgress = Color(0xffBF9A78);
  static const Color bullionProgressBg = Color(0xffADAAA7);

  static Color metalColor(String metalName) {
    switch (metalName.toLowerCase()) {
      case "gold":
        return AppColor.gold;
      case "silver":
        return AppColor.silver;
      case "platinum":
        return AppColor.platinum;
      case "palladium":
        return AppColor.palladium;
      default:
        return AppColor.primaryDark;
    }
  }

  static Color secondaryMetalColor(String metalName) {
    switch (metalName.toLowerCase()) {
      case "gold":
        return AppColor.secondaryGold;
      case "silver":
        return AppColor.secondarySilver;
      case "platinum":
        return AppColor.secondaryPlatinum;
      case "palladium":
        return AppColor.secondaryPalladium;
      default:
        return AppColor.header;
    }
  }

  static Color opacityMetalColor(String metalName) {
    switch (metalName.toLowerCase()) {
      case "gold":
        return const MaterialColor(
            0xFFF4BB40, {200: const Color.fromRGBO(244, 187, 64, .3)}).shade200;
      case "silver":
        return const MaterialColor(
                0xFF797979, {600: const Color.fromRGBO(121, 121, 121, .7)})
            .shade600;
      case "platinum":
        return const MaterialColor(
            0xFFEA616B, {700: const Color.fromRGBO(234, 97, 107, .8)}).shade700;
      case "palladium":
        return const MaterialColor(
            0xFF5F38B7, {600: const Color.fromRGBO(95, 56, 183, .7)}).shade600;
      default:
        return const MaterialColor(
            0xFF5F38B7, {200: const Color.fromRGBO(95, 56, 183, .3)}).shade200;
    }
  }

  static Color opacityColor(String metalName) {
    switch (metalName.toLowerCase()) {
      case "gold":
        return const Color(0xffFDF1D0);
      case "silver":
        return const Color(0xffE4E4E4);
      case "platinum":
        return const Color(0xffF9DEE1);
      case "palladium":
        return const Color(0xffDED7F0);
      default:
        return const Color(0xffFDF1D0);
    }
  }
}
