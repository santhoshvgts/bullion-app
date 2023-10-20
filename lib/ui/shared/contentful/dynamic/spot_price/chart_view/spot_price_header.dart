import 'package:bullion/core/models/chart/chart_selection_info.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:flutter/material.dart';

class SpotPriceHeader extends StatelessWidget {
  final ChartSelectionInfoModel _mySpotPrice;

  SpotPriceHeader(this._mySpotPrice);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25, left: 10),
      child: !_mySpotPrice.isSelected!
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      _mySpotPrice.formatedPrice!,
                      textScaleFactor: 1,
                      style: const TextStyle(
                          fontSize: 26,
                          color: AppColor.black,
                          fontWeight: FontWeight.w600),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    const Text(
                      'USD',
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.black,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      "${_mySpotPrice.changePct! > 0 ? "+" : "-"} " +
                          _mySpotPrice.formatedChange!,
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 16,
                          color: _mySpotPrice.changeColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Text(
                      "(${_mySpotPrice.changePct! > 0 ? "+" : ""}${_mySpotPrice.formatedChangePercentage})",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 14,
                          color: _mySpotPrice.changeColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Text(
                      _mySpotPrice.formatedDate!,
                      textScaleFactor: 1,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.secondaryText,
                      ),
                    ),

                    // Icon(
                    //   _mySpotPrice.changeIcon,
                    //   color: _mySpotPrice.changeColor,
                    // ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _mySpotPrice.formatedPrice!,
                      textScaleFactor: 1,
                      style: const TextStyle(
                          fontSize: 26,
                          color: AppColor.black,
                          fontWeight: FontWeight.w600),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    const Text(
                      'USD',
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.black,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    _mySpotPrice.formatedDate!,
                    textScaleFactor: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
