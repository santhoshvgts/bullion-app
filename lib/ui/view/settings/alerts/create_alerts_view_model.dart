import 'package:bullion/core/models/alert/alert_operators.dart';
import 'package:bullion/core/models/alert_add_response_model.dart';
import 'package:bullion/services/api_request/alerts_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class CreateAlertsViewModel extends VGTSBaseViewModel {
  OperatorsResponse? _operatorsResponse;

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

  void init() async {
    setBusy(true);

    _operatorsResponse =
        await request<OperatorsResponse>(AlertsRequest.getOperators());

    setBusy(false);
  }

  Future<bool> createMarketAlert() async {
    setBusy(true);
    AlertResponseModel? alertResponseModel = await request<AlertResponseModel>(
        AlertsRequest.postMarketAlert(
            double.parse(alertPriceFormFieldController.text),
            _operatorsResponse!.operators![_optionsSelectedIndex].id!,
            _metalsSelectedIndex + 1));

    setBusy(false);

    return alertResponseModel != null;
  }

  OperatorsResponse? get operatorsResponse => _operatorsResponse;
}
