import 'dart:async';
import 'dart:io';

import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/login_alert_section.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:bullion/core/enums/trade_entry_type.dart';

import '../locator.dart';
import '../services/shared/eventbus_service.dart';

Color getColorFromString(String? hexColor,
    {Color fallbackColor = Colors.transparent}) {
  if (hexColor == null || hexColor == "none" || hexColor == "")
    return fallbackColor;

  // Convert from RGB: rgb(24,23,23)
  if (hexColor.contains('rgb(')) {
    List<String> _bgList = hexColor
        .replaceAll("rgb", '')
        .replaceAll("(", '')
        .replaceAll(")", '')
        .replaceAll(" ", '')
        .split(",");
    return Color.fromRGBO(
        int.parse(_bgList[0]), int.parse(_bgList[1]), int.parse(_bgList[2]), 1);
  }

  // Convert from Hex Code: #ff2323
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

T? tryCast<T>(dynamic x, {T? fallback}) {
  try {
    return (x as T);
  } on TypeError catch (e) {
    print('TypeError when trying to cast $x to $T! Error ${e.toString()}');
    return fallback;
  }
}

T? getEnumFromString<T>(Iterable<T> values, String value) {
  if (value == null) {
    return null;
  }
  return values
      .firstWhereOrNull((type) => type.toString().split(".").last == value);
}

T? cast<T>(x) => x is T ? x : null;

bool isNull(Object? object) => object == null;

bool isNotNull(Object object) => object != null;

bool isNullOrEmpty(String? value) => isNull(value) || value!.isEmpty;

IconData FAIcon(String? name) {
  switch (name) {
    case "fa fa-exchange-alt":
      return FontAwesomeIcons.exchangeAlt;
    case "fa fa-credit-card":
      return FontAwesomeIcons.solidCreditCard;
    case "fab fa-paypal":
      return FontAwesomeIcons.paypal;
    case "fa fa-university":
      return FontAwesomeIcons.university;
    case "fab fa-cc-visa":
      return FontAwesomeIcons.ccVisa;
    case "fab fa-cc-mastercard":
      return FontAwesomeIcons.ccMastercard;
    case "fa fa-money-check":
      return FontAwesomeIcons.moneyCheck;
    case "fa fa-wallet":
      return FontAwesomeIcons.wallet;
    case "fa fa-chart-line":
      return FontAwesomeIcons.chartLine;
    case "fa fa-newspaper":
      return FontAwesomeIcons.newspaper;
    case "fab fa-bitcoin":
      return FontAwesomeIcons.bitcoin;
    case "fa fa-piggy-bank":
      return FontAwesomeIcons.piggyBank;
    default:
      return FontAwesomeIcons.circle;
  }
}

class QtyAmountInputOutPut {
  String? newValue;
  String? previousValue;
  String? input;
  String? output;
  int? outputPrecision;
  TradeEntryType? inputType;
  bool isValid = true;
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");
  final currencyFormatWithOneDecimal = new NumberFormat("#,##0.0", "en_US");
  final currencyFormatNoDecimal = new NumberFormat("#,##0", "en_US");

  QtyAmountInputOutPut(
      {this.input, this.previousValue, this.inputType, this.outputPrecision});

  String getFormattedOutPut() {
    newValue = previousValue;
    if (previousValue == "" && input == "") {
      previousValue = "0";
    }
    if (input == "DEL") {
      if (previousValue!.length > 0) {
        newValue = previousValue!.substring(0, previousValue!.length - 1);
      }
    } else {
      if (previousValue!.contains(".") && input == ".") {
        newValue = previousValue;
        isValid = false;
      } else if (input == ".") {
        newValue = previousValue! + ".";
        return _getFormattedValueByInputType((previousValue! + ".0"));
      } else {
        //if greater than 2 decimals
        if (previousValue!.contains(".") &&
            previousValue!.substring(previousValue!.indexOf(".") + 1).length >=
                outputPrecision!) {
          isValid = false;
          newValue = previousValue;
        } else {
          newValue = (previousValue == "0" ? "" : previousValue)! + input!;
        }
      }
    }

    if (newValue!.isEmpty) {
      newValue = "0";
    }
    return _getFormattedValueByInputType(newValue!);
  }

  String _getFormattedValueByInputType(String value) {
    print(inputType.toString());
    print("OUTPUT VALUE" + value);

    var output = value;
    if (inputType == TradeEntryType.AMOUNT) {
      if (value.contains(".")) {
        if (value.substring(newValue!.indexOf(".") + 1).length <= 1) {
          output = currencyFormatWithOneDecimal.format(double.parse(value));
        } else {
          output = currencyFormat.format(double.parse(value));
        }
      } else {
        output = currencyFormatNoDecimal.format(double.parse(value));
      }
      return r"$" + output;
    } else if (inputType == TradeEntryType.PERCENTAGE) {
      if (value.contains(".")) {
        if (value.substring(newValue!.indexOf(".") + 1).length <= 1) {
          output = (double.parse(value).toString());
        } else if (value.substring(newValue!.indexOf(".") + 1).length <=
            outputPrecision!) {
          output = (double.parse(value).toStringAsFixed(
              value.substring(newValue!.indexOf(".") + 1).length));
        } else if (value.substring(newValue!.indexOf(".") + 1).length >=
            outputPrecision!) {
          output = (double.parse(value).toStringAsFixed(outputPrecision!));
        }
      } else {
        output = double.parse(value).toString();
      }

      return output + " %";
    } else {
      if (value.contains(".")) {
        if (value.substring(newValue!.indexOf(".") + 1).length <= 1) {
          output = (double.parse(value).toString());
        } else if (value.substring(newValue!.indexOf(".") + 1).length <=
            outputPrecision!) {
          output = (double.parse(value).toStringAsFixed(
              value.substring(newValue!.indexOf(".") + 1).length));
        } else if (value.substring(newValue!.indexOf(".") + 1).length >=
            outputPrecision!) {
          output = (double.parse(value).toStringAsFixed(outputPrecision!));
        }
      } else {
        output = double.parse(value).toString();
      }
      return output + " OZ";
    }
  }
}

class Util {
  static showSnackBar(BuildContext context, String content) {
    SnackBar snackBar =
        SnackBar(content: Text(content, style: AppTextStyle.titleSmall));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showLoginAlert() {
    BuildContext context = locator<NavigationService>().navigatorKey.currentContext!;
    SnackBar snackBar = SnackBar(
      content: const LoginAlertSection(),
      duration: const  Duration(seconds: 5),
      action: SnackBarAction(label: "Sign In", onPressed: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        locator<NavigationService>().pushNamed(Routes.login);
      }),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showProductCheckout(ProductOverview overview) {
    BuildContext context = locator<NavigationService>().navigatorKey.currentContext!;
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Item Added to Cart", textScaleFactor: 1, style: AppTextStyle.titleSmall.copyWith(color: AppColor.green),),

          VerticalSpacing.d10px(),

          Row(
            children: [

              NetworkImageLoader(
                image: overview.primaryImageUrl,
                height: 30,
                width: 30,
              ),

              Expanded(child: Text(overview.name ?? '', style: AppTextStyle.titleSmall.copyWith(color: AppColor.text))),

              Button.mini("Checkout",
                  valueKey: const ValueKey("btnCheckout"),
                  color: AppColor.secondary,
                  borderColor: AppColor.secondary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    if (!locator<AuthenticationService>().isAuthenticated) {
                      Util.showLoginAlert();
                      return;
                    }
                    locator<NavigationService>().pushNamed(Routes.checkout);
                  }
              )
            ],
          ),

        ],
      ),
      duration: const  Duration(seconds: 60),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> cancelLockEvent() async {
    locator<EventBusService>()
        .eventBus
        .fire(DisableLockTimeoutEvent(disable: true));
  }

  static Future<void> enableLockEvent() async {
    locator<EventBusService>()
        .eventBus
        .fire(DisableLockTimeoutEvent(disable: false));
  }

  static int getDecimalPlaces(double? number) {
    int decimals = 0;
    List<String> substr = number.toString().split('.');
    if (substr.length > 0) decimals = int.parse(substr[1]);
    return decimals;
  }

  static Widget showArrowForward() {
    return Platform.isAndroid
        ? const Icon(Icons.arrow_forward)
        : const Icon(Icons.arrow_forward_ios);
  }

  static Widget showArrowBackward() {
    return Platform.isAndroid
        ? const Icon(Icons.arrow_back)
        : const Icon(Icons.arrow_back_ios);
  }

}
