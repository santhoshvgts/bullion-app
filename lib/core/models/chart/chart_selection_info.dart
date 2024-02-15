import 'package:bullion/core/models/chart/portfolio.dart';
import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartSelectionInfoModel {
  final currencyFormat = new NumberFormat.simpleCurrency(locale: "en_US");
  final dateFormat = DateFormat("yyyy-MM-dd h:mm:ss a");
  String? formatedPrice;
  String? formatedChange;
  String? formatedChangePercentage;
  String? formatedDate;
  String? formattedTotalAcquisitionCost;
  bool? isSelected;
  Color? changeColor;
  IconData? changeIcon;
  double? changePct = 0.0;

  String get chartToolTipDate =>
      DateFormat("MM/dd/yy hh:mm a").format(dateFormat.parse(formatedDate!));

  ChartSelectionInfoModel(
      {this.formatedPrice,
      this.formatedChange,
      this.formatedChangePercentage,
      this.formatedDate,
      this.isSelected,
      this.formattedTotalAcquisitionCost});

  ChartSelectionInfoModel.fromSelection(double? price, DateTime time,
      {String? cost}) {
    print(time);
    formatedPrice = currencyFormat.format(price);
    formatedDate = dateFormat.format(time);
    if (cost != null) {
      formattedTotalAcquisitionCost = cost;
    }
    isSelected = true;
  }

  ChartSelectionInfoModel.fromSpotPrice(SpotPrice metal) {
    formatedPrice = metal.formattedAsk;
    formatedChange = metal.formattedChange;
    formatedChangePercentage = "${metal.changePct}%";
    formatedDate = metal.formattedLastUpdated;
    changePct = metal.changePct;
    changeColor = metal.change! < 0 ? AppColor.red : AppColor.green;
    changeIcon =
        metal.change! < 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up;
    isSelected = false;
  }

  ChartSelectionInfoModel.fromPortfolio(Portfolio? metal) {
    formatedPrice = metal?.formattedTotalCurrentValue;
    formattedTotalAcquisitionCost = metal?.formattedTotalAcquisitionCost;
    formatedChange = metal?.formattedChange;
    formatedChangePercentage =
        metal == null ? "" : "${metal!.changePercentage}%";
    formatedDate = metal?.formattedChange;
    changePct = metal?.changePercentage ?? 0.0;
    changeColor = (metal?.change ?? 0) < 0 ? AppColor.red : AppColor.green;
    changeIcon =
        (metal?.change ?? 0) < 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up;
    isSelected = false;
  }
}
