import 'package:bullion/core/models/alert/product_alert_response_model.dart';
import 'package:bullion/services/api_request/alerts_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../core/models/alert/alert_response.dart';
import '../../../../locator.dart';
import '../../../../services/shared/dialog_service.dart';

class EditPriceAlertViewModel extends VGTSBaseViewModel {
  ProductAlert? productAlert;

  GlobalKey<FormState> priceAlertGlobalKey = GlobalKey<FormState>();

  NumberFormFieldController targetPriceFormFieldController =
      NumberFormFieldController(const Key("targetPrice"),
          required: true, requiredText: "Target Price can't be empty");

  void init(ProductAlert? productAlert) async {
    this.productAlert = productAlert;
    targetPriceFormFieldController.text = productAlert?.yourPrice.toString();
  }

  Future<bool> editMarketAlert() async {
    //setBusy(true);
    locator<DialogService>().showLoader();
    ProductAlert? productAlert = await request<ProductAlert>(
        AlertsRequest.editPriceAlert(this.productAlert?.productOverview?.productId, targetPriceFormFieldController.text
                ));

    //setBusy(false);
    notifyListeners();
    locator<DialogService>().dialogComplete(AlertResponse(status: true));

    return productAlert != null;
  }

}
