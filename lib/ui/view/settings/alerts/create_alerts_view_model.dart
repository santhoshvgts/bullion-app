import 'package:bullion/core/models/alert/alert_operators.dart';
import 'package:bullion/core/models/alert/alert_add_response_model.dart';
import 'package:bullion/services/api_request/alerts_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';
import 'package:vgts_plugin/form/utils/number_currency_format.dart';

import '../../../../core/models/alert/alert_response.dart';
import '../../../../locator.dart';
import '../../../../services/shared/dialog_service.dart';

class CreateAlertsViewModel extends VGTSBaseViewModel {
  OperatorsResponse? _operatorsResponse;
  AlertResponseModel? alertResponseModel;

  GlobalKey<FormState> customSpotPriceGlobalKey = GlobalKey<FormState>();

  FormFieldController alertPriceFormFieldController = AmountFormFieldController(const Key("targetPrice"),
      required: true,
      requiredText: "Alert Price can't be empty",
      maxLength: 12,
      maxAmount: 1000000,
      currencyFormat: NumberCurrencyFormat(
          "USD",
          "en_US",
          "\$",
          2
      )
  );


  int _metalsSelectedIndex = 0;
  int _optionsSelectedIndex = 0;

  final List<String> metalsList = ['Gold', 'Silver', 'Platinum', 'Palladium'];

  /*final List<String> optionsList = [
    'Rises Above \$',
    'Falls Below \$',
    'Increases By \%',
    'Decrease By \%'
  ];*/

  int get metalsSelectedIndex => _metalsSelectedIndex;

  set metalsSelectedIndex(int value) {
    _metalsSelectedIndex = value;
    notifyListeners();
  }

  int get optionsSelectedIndex => _optionsSelectedIndex;

  set optionsSelectedIndex(int value) {
    if (_optionsSelectedIndex != value) {
      String text = alertPriceFormFieldController.text;
      if (operatorsResponse?.operators?[value].description?.contains("%") == true){
        alertPriceFormFieldController = NumberFormFieldController(const ValueKey("txtAlert"), maxLength: 6, required: true, requiredText: "Alert Price can't be empty");
        alertPriceFormFieldController.text = "";
      } else {
        alertPriceFormFieldController = AmountFormFieldController(const Key("targetPrice"),
            required: true,
            requiredText: "Alert Price can't be empty",
            maxLength: 12,
            maxAmount: 1000000,
            currencyFormat: NumberCurrencyFormat(
                "USD",
                "en_US",
                "\$",
                2
            )
        );
        alertPriceFormFieldController.text = text;
      }



    }
    _optionsSelectedIndex = value;

    notifyListeners();
  }

  void init(AlertResponseModel? alertResponseModel, String? metalName) async {
    setBusy(true);
    this.alertResponseModel = alertResponseModel;

    _operatorsResponse =
        await request<OperatorsResponse>(AlertsRequest.getOperators());

    if (alertResponseModel != null && _operatorsResponse != null) {
      alertPriceFormFieldController.text = alertResponseModel.price.toString();
      _metalsSelectedIndex = alertResponseModel.metal! - 1;

      for (var i = 0; i < _operatorsResponse!.operators!.length; i++) {
        if (_operatorsResponse!.operators?[i].id ==
            alertResponseModel.operatorId) {
          _optionsSelectedIndex = i;
          break;
        }
      }
    } else if (metalName != null) {
      _metalsSelectedIndex = metalsList.indexOf(metalName);
    }

    setBusy(false);
  }

  Future<bool> createEditMarketAlert() async {
    //setBusy(true);
    locator<DialogService>().showLoader();
    AlertResponseModel? alertResponseModel = await request<AlertResponseModel>(
        this.alertResponseModel != null
            ? AlertsRequest.createEditMarketAlert(
                this.alertResponseModel!.id!,
                double.parse(alertPriceFormFieldController.text),
                _operatorsResponse!.operators![_optionsSelectedIndex].id!,
                _metalsSelectedIndex + 1,
                false)
            : AlertsRequest.createEditMarketAlert(
                0,
                double.parse(alertPriceFormFieldController.text),
                _operatorsResponse!.operators![_optionsSelectedIndex].id!,
                _metalsSelectedIndex + 1,
                true));

    //setBusy(false);
    notifyListeners();
    locator<DialogService>().dialogComplete(AlertResponse(status: true));

    return alertResponseModel != null;
  }

  OperatorsResponse? get operatorsResponse => _operatorsResponse;
}
