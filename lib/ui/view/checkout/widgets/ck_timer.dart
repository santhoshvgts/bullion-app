import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CkTimer extends ViewModelWidget<CheckoutPageViewModel> {
  const CkTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Chip(
        backgroundColor: AppColor.primary,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        label: Text(viewModel.formattedRemainingPricingTime, style: AppTextStyle.labelLarge.copyWith(color: AppColor.white)),
      ),
    );
  }
}
