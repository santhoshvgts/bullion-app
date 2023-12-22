import 'package:bullion/core/models/alert/alert_operators.dart';
import 'package:bullion/core/models/alert/alert_add_response_model.dart';
import 'package:bullion/services/api_request/alerts_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../core/models/alert/alert_response.dart';
import '../../../../locator.dart';
import '../../../../services/shared/dialog_service.dart';

class CreateAlertsViewModel extends VGTSBaseViewModel {
  OperatorsResponse? _operatorsResponse;
  AlertResponseModel? alertResponseModel;

  GlobalKey<FormState> customSpotPriceGlobalKey = GlobalKey<FormState>();

  NumberFormFieldController alertPriceFormFieldController =
      NumberFormFieldController(const Key("alertPrice"),
          required: true, requiredText: "Alert Price can't be empty");

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
    _optionsSelectedIndex = value;
    notifyListeners();
  }

  void init(AlertResponseModel? alertResponseModel) async {
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
