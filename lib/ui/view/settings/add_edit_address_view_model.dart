import 'package:bullion/ui/view/settings/add_edit_address_page.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class AddEditAddressViewModel extends VGTSBaseViewModel {

  FormFieldController addressFormController = FormFieldController(Key("addressFormKey"));

  bool? isDefaultAddress = false;
  AddressType _selectedAddressType = AddressType.home;

  init() {

  }

  void selectDefaultAddress() {
    isDefaultAddress = !isDefaultAddress!;
    debugPrint("isDefaultAddress: $isDefaultAddress");
    notifyListeners();
  }

  AddressType get selectedAddressType => _selectedAddressType;

  set selectedAddressType(AddressType value) {
    _selectedAddressType = value;
    notifyListeners();
  }
}