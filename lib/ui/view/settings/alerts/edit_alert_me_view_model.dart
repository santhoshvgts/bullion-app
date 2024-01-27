import 'package:bullion/core/models/alert/product_alert_response_model.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_item.dart' as product_item;
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/services/api_request/alerts_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../core/models/alert/alert_response.dart';
import '../../../../locator.dart';
import '../../../../services/shared/dialog_service.dart';

class EditAlertMeViewModel extends VGTSBaseViewModel {
  ProductOverview? productOverview;
  ProductDetails? productDetails;

  GlobalKey<FormState> priceAlertGlobalKey = GlobalKey<FormState>();

  NumberFormFieldController quantityFormFieldController =
      NumberFormFieldController(const Key("quantity"),
          required: true, requiredText: "Quantity can't be empty");

  void init(ProductOverview? data) async {
    productOverview = data;
    productDetails = await request<ProductDetails>(AlertsRequest.getPriceAlertById(data!.productId!));

    if (productDetails != null) {
      quantityFormFieldController.text = productDetails?.requestedQty.toString();
    }
  }

  Future<bool> editAlertMe() async {
    //setBusy(true);
    locator<DialogService>().showLoader();
    ProductDetails? productAlert = await request<ProductDetails>(AlertsRequest.editAlertMe(productOverview!.productId, quantityFormFieldController.text));

    //setBusy(false);
    notifyListeners();
    locator<DialogService>().dialogComplete(AlertResponse(status: true));

    return productAlert != null;
  }
}
