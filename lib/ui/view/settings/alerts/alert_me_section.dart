import 'package:bullion/core/models/alert/product_alert_response_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/res/images.dart';
import '../../../../core/res/styles.dart';
import 'alert_me_view_model.dart';

class AlertMePage extends VGTSBuilderWidget<AlertMeViewModel> {
  List<ProductAlert>? alertMeAlerts;

  AlertMePage(this.alertMeAlerts, {super.key});

  @override
  AlertMeViewModel viewModelBuilder(BuildContext context) {
    return AlertMeViewModel();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      AlertMeViewModel viewModel, Widget? child) {
    /*return viewModel.filteredList == null
        ? const Center(child: Text("No data available"))
        : Container();*/
    return alertMeAlerts == null
        ? const Center(child: Text("No data available"))
        : Scaffold(
            body: alertMeAlerts!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, right: 16.0),
                    child: Text(alertMeAlerts?.length.toString() ?? ""),
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
                          "No Alerts found",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.titleLarge,
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "You can manage your product back-in-stock notifications on this page. We will send you an email and/or SMS when the product is available to purchase. Sign up to be notified when a product comes back in-stock by clicking the “Notify Me” button on a product page.",
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
