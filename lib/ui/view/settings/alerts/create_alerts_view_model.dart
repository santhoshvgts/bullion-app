import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class CreateAlertsViewModel extends VGTSBaseViewModel {
  GlobalKey<FormState> customSpotPriceGlobalKey = GlobalKey<FormState>();

  NumberFormFieldController alertPriceFormFieldController =
      NumberFormFieldController(const Key("alertPrice"),
          required: true, requiredText: "Alert Price can't be empty");

  int _metalsSelectedIndex = 0;
  int _optionsSelectedIndex = 0;

  final List<String> metalsList = ['Gold', 'Silver', 'Platinum', 'Palladium'];

  final List<String> optionsList = [
    'Rises Above \$',
    'Falls Below \$',
    'Increases By \%',
    'Decrease By \%'
  ];

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
}
