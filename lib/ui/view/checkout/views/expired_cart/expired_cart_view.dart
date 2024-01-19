// ignore_for_file: must_be_immutable

import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/ui/view/checkout/views/expired_cart/expired_cart_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../services/shared/navigator_service.dart';

class ExpiredCartView extends VGTSBuilderWidget<ExpiredCartViewModel> {
  bool? fromPriceExpiry = false;

  ExpiredCartView({required this.fromPriceExpiry, Key? key}) : super(key: key);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ExpiredCartViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: fromPriceExpiry! ? false : true,
        title: Text(
          fromPriceExpiry! ? "Price Expired" : "Review Order",
          textScaleFactor: 1,
        ),
        actions: [
          if (fromPriceExpiry!)
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  locator<NavigationService>().popUntil(Routes.dashboard);
                })
        ],
      ),
      body: Center(child: Text('Review CART PAGE')),
    );
  }

  @override
  ExpiredCartViewModel viewModelBuilder(BuildContext context) {
    return ExpiredCartViewModel();
  }
}
