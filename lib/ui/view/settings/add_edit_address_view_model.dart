import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/ui/view/settings/add_edit_address_page.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../services/api_request/address_request.dart';

class AddEditAddressViewModel extends VGTSBaseViewModel {
  FormFieldController addressFormController =
      FormFieldController(const Key("addressFormKey"));

  bool? _isDefaultAddress = false;
  AddressType _selectedAddressType = AddressType.home;

  UserAddress? userAddressResult, editUserAddress;

  GlobalKey<FormState> addEditAddressGlobalKey = GlobalKey<FormState>();

  NameFormFieldController firstNameFormFieldController =
      NameFormFieldController(const Key("txtName"),
          required: true, requiredText: "First Name can't be empty");
  NameFormFieldController lastNameFormFieldController = NameFormFieldController(
      const Key("txtName"),
      required: true,
      requiredText: "Last Name can't be empty");
  NameFormFieldController companyFormFieldController =
      NameFormFieldController(const Key("txtCompany"), required: false);
  PhoneFormFieldController phoneFormFieldController = PhoneFormFieldController(
      const Key("numContact"),
      required: true, maxLength: 11,
      requiredText: "Phone number can't be empty");
  NumberFormFieldController pinFormFieldController = NumberFormFieldController(
      const Key("numPin"),
      required: true,
      requiredText: "Pin code can't be empty");
  TextFormFieldController cityFormFieldController = TextFormFieldController(
      const Key("txtLocality"),
      required: true,
      requiredText: "City can't be empty");
  TextFormFieldController countryFormFieldController = TextFormFieldController(
      const Key("txtCountry"),
      required: true,
      requiredText: "Country can't be empty");
  NameFormFieldController stateFormFieldController =
      NameFormFieldController(const Key("txtName"), required: false);
  TextFormFieldController streetFormFieldController = TextFormFieldController(
      const Key("txtLocality"),
      required: true,
      requiredText: "Street Address can't be empty");
  TextFormFieldController buildingFormFieldController =
      TextFormFieldController(const Key("txtBuilding"));

  init(UserAddress? editUserAddress) {
    this.editUserAddress = editUserAddress;
    if(editUserAddress != null) {
      firstNameFormFieldController.text = editUserAddress.firstName ?? "";
      lastNameFormFieldController.text = editUserAddress.lastName ?? "";
      companyFormFieldController.text = editUserAddress.company ?? "";
      streetFormFieldController.text = editUserAddress.add1 ?? "";
      cityFormFieldController.text = editUserAddress.city ?? "";
      countryFormFieldController.text = editUserAddress.country ?? "";
      stateFormFieldController.text = editUserAddress.state ?? "";
      pinFormFieldController.text = editUserAddress.zip ?? "";
      phoneFormFieldController.text = editUserAddress.primaryPhone?.trimRight() ?? "";
      _isDefaultAddress = editUserAddress.isDefault;
    }
  }

  void selectDefaultAddress() {
    _isDefaultAddress = !isDefaultAddress!;
    debugPrint("isDefaultAddress: $isDefaultAddress");
    notifyListeners();
  }

  Future<bool> submitAddress() async {
    setBusy(true);

    UserAddress userAddress = UserAddress();
    editUserAddress != null ? userAddress.id = editUserAddress?.id : userAddress.id = 0;
    userAddress.isValidated = true;
    userAddress.overrideValidation = false;

    userAddress.isDefault = isDefaultAddress;
    userAddress.firstName = firstNameFormFieldController.text;
    userAddress.lastName = lastNameFormFieldController.text;
    userAddress.company = companyFormFieldController.text;
    userAddress.add1 = streetFormFieldController.text;
    userAddress.city = cityFormFieldController.text;
    userAddress.country = countryFormFieldController.text;
    userAddress.state = stateFormFieldController.text;
    userAddress.zip = pinFormFieldController.text;
    userAddress.primaryPhone = phoneFormFieldController.text;

    userAddressResult = await request<UserAddress>(
        AddressRequest.addAddress(userAddress.toJson()));

    setBusy(false);
    if (userAddressResult != null) {
      return true;
    } else {
      return false;
    }
  }

  AddressType get selectedAddressType => _selectedAddressType;

  set selectedAddressType(AddressType value) {
    _selectedAddressType = value;
    notifyListeners();
  }

  bool? get isDefaultAddress => _isDefaultAddress;
}