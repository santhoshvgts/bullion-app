import 'package:bullion/core/models/alert/product_alert_response_model.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/services/api_request/alerts_request.dart';
import 'package:bullion/services/push_notification_service.dart';
import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';
import 'package:vgts_plugin/form/utils/number_currency_format.dart';

import '../../../../core/models/alert/alert_response.dart';
import '../../../../locator.dart';
import '../../../../services/shared/dialog_service.dart';

class EditPriceAlertViewModel extends VGTSBaseViewModel {
  ProductDetails? productDetails;
  ProductOverview? productOverview;

  GlobalKey<FormState> priceAlertGlobalKey = GlobalKey<FormState>();

  AmountFormFieldController targetPriceFormFieldController = AmountFormFieldController(const Key("targetPrice"),
    required: true,
    requiredText: "Target Price can't be empty",
    currencyFormat: NumberCurrencyFormat(
      "USD",
      "en_US",
      "\$",
      2
    )
  );

  void init(ProductOverview? data) async {
    productOverview = data;

    setBusyForObject(productDetails, true);
    productDetails = await request<ProductDetails>(AlertsRequest.getPriceAlertById(data!.productId!));
    setBusyForObject(productDetails, false);

    if ((productDetails?.yourPrice ?? 0) != 0) {
      targetPriceFormFieldController.text = productDetails?.yourPrice.toString();
    }
    targetPriceFormFieldController.focusNode.requestFocus();
  }

  Future<bool> savePriceAlert() async {
    setBusy(true);
    ProductDetails? productAlert = await request<ProductDetails>(AlertsRequest.editPriceAlert(productOverview!.productId, targetPriceFormFieldController.text));
    setBusy(false);

    bool hasNotificationPermission = await locator<PushNotificationService>().checkPermissionAndPromptSettings(
        "Price Alert Created",
        description: "Know instantly when your price alerts get triggered. Please enable push notifications to get notified instantly."
    );
    return productAlert != null;
  }

}
