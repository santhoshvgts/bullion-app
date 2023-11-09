import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../core/models/alert/alert_response.dart';
import '../../../core/models/module/checkout/shipping_address.dart';
import '../../../core/models/module/selected_item_list.dart';
import '../../../locator.dart';
import '../../../services/api_request/address_request.dart';
import '../../../services/shared/dialog_service.dart';
import 'bottom_sheets/select_country_state_bottomsheet.dart';

class AddEditAddressViewModel extends VGTSBaseViewModel {
  FormFieldController addressFormController =
      FormFieldController(const Key("addressFormKey"));

  bool? _isDefaultAddress = false;
  bool _stateEnable = false;

  //AddressType _selectedAddressType = AddressType.home;

  UserAddress? userAddressResult, editUserAddress;
  ShippingAddress? _shippingAddress;

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
      required: true,
      maxLength: 11,
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

  TextEditingController searchController = TextEditingController();

  FocusNode searchFocus = FocusNode();

  init(UserAddress? editUserAddress) {
    this.editUserAddress = editUserAddress;
    if (editUserAddress != null) {
      firstNameFormFieldController.text = editUserAddress.firstName ?? "";
      lastNameFormFieldController.text = editUserAddress.lastName ?? "";
      companyFormFieldController.text = editUserAddress.company ?? "";
      streetFormFieldController.text = editUserAddress.add1 ?? "";
      cityFormFieldController.text = editUserAddress.city ?? "";
      countryFormFieldController.text = editUserAddress.country ?? "";
      stateFormFieldController.text = editUserAddress.state ?? "";
      pinFormFieldController.text = editUserAddress.zip ?? "";
      phoneFormFieldController.text =
          editUserAddress.primaryPhone?.trimRight() ?? "";
      _isDefaultAddress = editUserAddress.isDefault;
    } else {
      initAddress();
    }
  }

  void selectDefaultAddress() {
    _isDefaultAddress = !isDefaultAddress!;
    notifyListeners();
  }

  void initAddress() async {
    setBusy(true);

    _shippingAddress =
        await request<ShippingAddress>(AddressRequest.getAvailableCountries());

    List<SelectedItemList> country = _shippingAddress!.availableCountries!
        .where((element) => element.selected == true)
        .toList();
    if (country.isNotEmpty) countryFormFieldController.text = country[0].text!;

    List<SelectedItemList> state = _shippingAddress!.availableStates!
        .where((element) => element.selected == true)
        .toList();
    if (state.isNotEmpty) stateFormFieldController.text = state[0].text!;

    firstNameFormFieldController.focusNode.requestFocus();

    setBusy(false);
  }

  Future<bool> submitAddress() async {
    setBusy(true);

    UserAddress userAddress = UserAddress();
    editUserAddress != null
        ? userAddress.id = editUserAddress?.id
        : userAddress.id = 0;
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

  /*AddressType get selectedAddressType => _selectedAddressType;

  set selectedAddressType(AddressType value) {
    _selectedAddressType = value;
    notifyListeners();
  }*/

  bool? get isDefaultAddress => _isDefaultAddress;

  void showCountries() async {
    searchController.clear();
    AlertResponse response = await locator<DialogService>().showBottomSheet(
        title: "Select Country",
        child: SelectCountryStateBottomSheet(_shippingAddress, true),
        showActionBar: true);

    if (response.data != null) {
      setBusy(true);

      countryFormFieldController.text = response.data.text;
      stateFormFieldController.clear();

      shippingAddress?.availableStates = await requestList<SelectedItemList>(
          AddressRequest.getAvailableStates(response.data.value));

      if (shippingAddress!.availableStates!.isEmpty) {
        _stateEnable = true;
        stateFormFieldController.focusNode.requestFocus();
      } else {
        _stateEnable = false;
        notifyListeners();
        showStates();
      }

      setBusy(false);
    }
    notifyListeners();
  }

  void showStates() async {
    searchController.clear();
    AlertResponse response = await locator<DialogService>().showBottomSheet(
        title: "Select State",
        child: SelectCountryStateBottomSheet(_shippingAddress, false),
        showActionBar: true);

    if (response.data != null) {
      stateFormFieldController.text = response.data.text;
      pinFormFieldController.focusNode.requestFocus();
    }
    notifyListeners();
  }

  List<SelectedItemList>? get countryList => _shippingAddress == null
      ? []
      : searchController.text.isEmpty
          ? _shippingAddress!.availableCountries
          : _shippingAddress!.availableCountries!
              .where((i) => i.text!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();

  List<SelectedItemList>? get stateList => _shippingAddress == null
      ? []
      : searchController.text.isEmpty
          ? _shippingAddress!.availableStates
          : _shippingAddress!.availableStates!
              .where((i) => i.text!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();

  ShippingAddress? get shippingAddress => _shippingAddress;

  bool get stateEnable => _stateEnable;
}
