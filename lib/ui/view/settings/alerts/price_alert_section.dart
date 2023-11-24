import 'package:bullion/core/models/alert/product_alert_response_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/res/images.dart';
import '../../../../core/res/styles.dart';
import 'alerts_view_model.dart';

class PriceAlertPage extends VGTSBuilderWidget<AlertsViewModel> {
  List<ProductAlert>? productAlerts;

  PriceAlertPage(this.productAlerts, {super.key});

  @override
  AlertsViewModel viewModelBuilder(BuildContext context) {
    return AlertsViewModel();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      AlertsViewModel viewModel, Widget? child) {
    return productAlerts == null
        ? const Center(child: Text("No data available"))
        : Scaffold(
            body: productAlerts!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, right: 16.0),
                    child: Text(productAlerts?.length.toString() ?? ""),
                  )
                : Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.5,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Images.cartIcon,
                          width: 150,
                        ),
                        const SizedBox(height: 32.0),
                        const Text(
                          "Price alerts are empty",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.titleLarge,
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Our price notification tool makes it easy to know when a product has reached your ideal price for purchase. You can manage your price alerts on this page. We will send you an email and/or SMS when the product has reached your price alert set price. Sign up to be notified for price alerts by clicking the bell icon on a product page.",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bodySmall,
                        ),
                      ],
                    ),
                  ),
          );
  }
}
