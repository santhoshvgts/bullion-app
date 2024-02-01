import 'package:bullion/core/models/chart/chart_selection_info.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/spot_price_chart_view_model.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../helper/utils.dart';

class SpotPriceHeader extends StatelessWidget {
  final ChartSelectionInfoModel _mySpotPrice;
  final SpotPriceChartViewModel _viewModel;

  const SpotPriceHeader(this._viewModel, this._mySpotPrice, {super.key});

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

                    Text(
                      DateFormat("dd-MMM-yy hh:mm a").format(
                        DateFormat("yyyy-MM-dd hh:mm:ss a").parse(
                          (_mySpotPrice.formatedDate!),
                        ),
                      ),
                      
                      style: AppTextStyle.bodySmall.copyWith(
                        fontSize: 13,
                        color: AppColor.secondaryText,
                      ),
                    ),

                    VerticalSpacing.d2px(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          _mySpotPrice.formatedPrice!,
                          
                          style: AppTextStyle.headlineMedium.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                        HorizontalSpacing.d5px(),
                      ],
                    ),
                    VerticalSpacing.d2px(),
                    !_mySpotPrice.isSelected!
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                "${_mySpotPrice.changePct! > 0 ? "" : "-"} ${_mySpotPrice.formatedChange!}",
                                
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
                                
                                style: AppTextStyle.labelMedium.copyWith(
                                  color: _mySpotPrice.changeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(
                      height: 20,
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
                  onPressed: () {
                    if (!locator<AuthenticationService>().isAuthenticated) {
                      Util.showLoginAlert();
                      return;
                    }
                    bool isAuthenticated = _viewModel.createSpotPrice();
                  },
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
                      
                      style: AppTextStyle.labelMedium,
                    ),
                    Text(
                      _viewModel.spotPriceChartData?.formattedBid ?? '',
                      
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
                      
                      style: AppTextStyle.labelMedium,
                    ),
                    Text(
                      _viewModel.spotPriceChartData?.formattedAsk ?? '',
                      
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
