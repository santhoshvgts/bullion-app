import 'package:bullion/locator.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/preference_service.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/res/styles.dart';

class CkNotes extends ViewModelWidget<CheckoutPageViewModel> {
  const CkNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 150),
        child: Text(
          "Checkout confirmation and updates will be emailed to\n${locator<AuthenticationService>().getUser?.email ?? ''} | Cart Id: ${locator<PreferenceService>().getCartId() ?? ''}",
          style: AppTextStyle.labelSmall.copyWith(color: Colors.black45),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
