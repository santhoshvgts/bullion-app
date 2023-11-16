import 'package:flutter/material.dart';

class AppColor {
  static const Color primary = Color(0xFF006936);
  static Color primary60 = const Color(0xFF006936).withOpacity(0.6);

  static const Color indicatorColor = Color(0xFFB8F5D4);
  static const Color primaryDark = Color(0xFF002539);
  static const Color secondary = Color(0xFFf25d0d);
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
  static const Color warning = Color(0xffFF3B30);
  static const Color blue = Color(0xFF005f9b);
  static const Color info = Color(0xFFFF9800);

  static const Color dealsRed = Color(0xFFC30000);
  static const Color black20 = Color(0xFF344456);

  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineBorder = Color(0xFFC1C2B8);

  static const Color bullion = Color(0xff001A29);
  static const Color bullionBg = Color(0xffFFFDF2);
  static const Color bullionProgress = Color(0xffBF9A78);
  static const Color bullionProgressBg = Color(0xffADAAA7);

  static const Color accountBg = Color(0x0D006936);

  @deprecated // Use secondaryTextColor instead
  static const Color navyBlue40 = Color(0x6614203C);

  static const Color mercury = Color(0xffE6E6E6);
  static const Color clearBlue = Color(0xff1B84FF);
  static const Color cyanBlue = Color(0xff2D81E3);
  static const Color platinumColor = Color(0xffe2e2e2);
  static const Color snowDrift = Color(0xffF9F9F9);
  static const Color iconBG = Color(0xffF5F5F5);
  static const Color turtleGreen = Color(0xff429283);
  static const Color redOrange = Color(0xffFF3B30);
  static const Color concord = Color(0xff7C7C7C);
  static const Color orangePeel = Color(0xffFF9800);
  static const Color eggSour = Color(0xffFFF3E0);
  static const Color mintGreen = Color(0xff31BF65);
  static const Color sherwoodGreen = Color(0xff00372E);

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
        return const Color(0xffFFDB7F);
      case "silver":
        return const Color(0xffC9C9C9);
      case "platinum":
        return const Color(0xffFEAAB3);
      case "palladium":
        return const Color(0xffCAB9E8);
      default:
        return const Color(0xffFFDB7F);
    }
  }
}
