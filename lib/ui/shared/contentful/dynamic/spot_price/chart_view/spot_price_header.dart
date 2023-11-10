import 'package:bullion/core/models/chart/chart_selection_info.dart';
import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpotPriceHeader extends StatelessWidget {
  final SpotPrice spotPrice;
  final ChartSelectionInfoModel _mySpotPrice;

  SpotPriceHeader(this.spotPrice, this._mySpotPrice);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !_mySpotPrice.isSelected!
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                "${_mySpotPrice.changePct! > 0 ? "+" : "-"} ${_mySpotPrice.formatedChange!}",
                                textScaleFactor: 1,
                                style: AppTextStyle.labelMedium.copyWith(
                                  color: _mySpotPrice.changeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              Text(
                                "(${_mySpotPrice.changePct! > 0 ? "+" : ""}${_mySpotPrice.formatedChangePercentage})",
                                textScaleFactor: 1,
                                style: AppTextStyle.labelMedium.copyWith(
                                  color: _mySpotPrice.changeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.only(left: 5),
                              // ),
                              // Text(
                              //   _mySpotPrice.formatedDate!,
                              //   textScaleFactor: 1,
                              //   style: AppTextStyle.bodySmall.copyWith(
                              //     fontSize: 13,
                              //     color: AppColor.secondaryText,
                              //   ),
                              // ),

                              // Icon(
                              //   _mySpotPrice.changeIcon,
                              //   color: _mySpotPrice.changeColor,
                              // ),
                            ],
                          )
                        : const SizedBox(
                            height: 20,
                          ),
                    VerticalSpacing.d2px(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          _mySpotPrice.formatedPrice!,
                          textScaleFactor: 1,
                          style: AppTextStyle.headlineMedium.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                        HorizontalSpacing.d5px(),
                      ],
                    ),
                    VerticalSpacing.d2px(),
                    Text(
                      DateFormat("dd-MMM-yy hh:mm a").format(
                        DateFormat("yyyy-MM-dd hh:mm:ss a").parse(
                          (_mySpotPrice.formatedDate!),
                        ),
                      ),
                      textScaleFactor: 1,
                      style: AppTextStyle.bodySmall.copyWith(
                        fontSize: 13,
                        color: AppColor.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Button.outline(
                  "Create Alert",
                  iconWidget: const Icon(
                    CupertinoIcons.alarm,
                    size: 14,
                    color: AppColor.primary,
                  ),
                  borderColor: AppColor.primary,
                  textStyle:
                      AppTextStyle.labelSmall.copyWith(color: AppColor.primary),
                  height: 35,
                  valueKey: const ValueKey("btnAlert"),
                  onPressed: () {},
                ),
              ),

              // Container(
              //   decoration: const BoxDecoration(
              //     color: AppColor.secondaryBackground,
              //     shape: BoxShape.circle,
              //   ),
              //   width: 35,
              //   height: 35,
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       CupertinoIcons.alarm,
              //       size: 20,
              //     ),
              //   ),
              // )
            ],
          ),
          VerticalSpacing.d10px(),
          const Divider(color: AppColor.divider, thickness: 0.5),
          VerticalSpacing.d10px(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bid Price",
                      textScaleFactor: 1,
                      style: AppTextStyle.labelMedium,
                    ),
                    Text(
                      spotPrice.formattedBid ?? '',
                      textScaleFactor: 1,
                      style: AppTextStyle.bodyLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ask Price",
                      textScaleFactor: 1,
                      style: AppTextStyle.labelMedium,
                    ),
                    Text(
                      spotPrice.formattedAsk ?? '',
                      textScaleFactor: 1,
                      style: AppTextStyle.bodyLarge,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
