import 'package:bullion/core/models/module/dynamic.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/ui/view/settings/address/address_recommend_bottomsheet.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../core/models/alert/alert_response.dart';
import '../../../../core/models/google/place.dart';
import '../../../../core/models/google/place_autocomplete.dart';
import '../../../../core/models/module/checkout/shipping_address.dart';
import '../../../../core/models/module/selected_item_list.dart';
import '../../../../locator.dart';
import '../../../../services/api/google_place_api.dart';
import '../../../../services/api_request/address_request.dart';
import '../../../../services/shared/dialog_service.dart';
import '../bottom_sheets/select_country_state_bottomsheet.dart';

class AddEditAddressViewModel extends VGTSBaseViewModel {

  bool loading = false;

  bool? fromCheckout = false;

  GooglePlaceApi? googlePlaceApi = locator<GooglePlaceApi>();

  FormFieldController addressFormController = FormFieldController(const Key("addressFormKey"));

  bool? _isDefaultAddress = false;
  bool _stateEnable = false;

  //AddressType _selectedAddressType = AddressType.home;
  SelectAddress _selectedAddress = SelectAddress.Suggested;

  SelectAddress get selectedAddress => _selectedAddress;

  void setAddress(SelectAddress viewState) {
    _selectedAddress = viewState;
    notifyListeners();
  }

  UserAddress? editUserAddress;
  ShippingAddress? _shippingAddress;

  GlobalKey<FormState> addEditAddressGlobalKey = GlobalKey<FormState>();

  NameFormFieldController firstNameFormFieldController = NameFormFieldController(const Key("txtName"), required: true, requiredText: "First Name can't be empty");
  NameFormFieldController lastNameFormFieldController = NameFormFieldController(const Key("txtName"), required: true, requiredText: "Last Name can't be empty");
  NameFormFieldController companyFormFieldController = NameFormFieldController(const Key("txtCompany"), required: false);
  PhoneFormFieldController phoneFormFieldController = PhoneFormFieldController(const Key("numContact"), required: true, maxLength: 11, requiredText: "Contact number can't be empty");
  NumberFormFieldController pinFormFieldController = NumberFormFieldController(const Key("numPin"), required: true, requiredText: "Pin code can't be empty");
  TextFormFieldController cityFormFieldController = TextFormFieldController(const Key("txtCity"), required: true, requiredText: "City can't be empty");
  TextFormFieldController countryFormFieldController = TextFormFieldController(const Key("txtCountry"), required: true, requiredText: "Country can't be empty");
  NameFormFieldController stateFormFieldController = NameFormFieldController(const Key("txtName"), required: false);

  bool streetValidate = false;

  TextEditingController streetTextEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  FocusNode streetFocus = FocusNode();
  FocusNode searchFocus = FocusNode();

  List<SelectedItemList>? get countryList => _shippingAddress == null
      ? []
      : searchController.text.isEmpty
      ? _shippingAddress!.availableCountries
      : _shippingAddress!.availableCountries!.where((i) => i.text!.toLowerCase().contains(searchController.text.toLowerCase())).toList();

  List<SelectedItemList>? get stateList => _shippingAddress == null
      ? []
      : searchController.text.isEmpty
      ? _shippingAddress!.availableStates
      : _shippingAddress!.availableStates!.where((i) => i.text!.toLowerCase().contains(searchController.text.toLowerCase())).toList();

  ShippingAddress? get shippingAddress => _shippingAddress;

  bool get stateEnable => _stateEnable;

  bool? get isDefaultAddress => _isDefaultAddress;

  AddEditAddressViewModel(this.fromCheckout);

  init(UserAddress? editUserAddress) async {
    setBusy(true);

    this.editUserAddress = editUserAddress;

    _shippingAddress = await request<ShippingAddress>(AddressRequest.getAvailableCountries());

    if (editUserAddress != null) {
      firstNameFormFieldController.text = editUserAddress.firstName ?? "";
      lastNameFormFieldController.text = editUserAddress.lastName ?? "";
      companyFormFieldController.text = editUserAddress.company ?? "";
      streetTextEditingController.text = editUserAddress.add1 ?? "";
      cityFormFieldController.text = editUserAddress.city ?? "";
      countryFormFieldController.text = editUserAddress.country ?? "";
      stateFormFieldController.text = editUserAddress.state ?? "";
      pinFormFieldController.text = editUserAddress.zip ?? "";
      phoneFormFieldController.text = editUserAddress.primaryPhone?.trimRight() ?? "";
      _isDefaultAddress = editUserAddress.isDefault;
    } else {
      initAddAddress();
    }

    setBusy(false);
  }

  void selectDefaultAddress() {
    _isDefaultAddress = !isDefaultAddress!;
    notifyListeners();
  }

  initAddAddress() async {
    List<SelectedItemList> country = _shippingAddress!.availableCountries!.where((element) => element.selected == true).toList();
    if (country.isNotEmpty) countryFormFieldController.text = country[0].text!;

    List<SelectedItemList> state = _shippingAddress!.availableStates!.where((element) => element.selected == true).toList();
    if (state.isNotEmpty) stateFormFieldController.text = state[0].text!;

    firstNameFormFieldController.focusNode.requestFocus();
  }

  submitAddress() async {
    if (addEditAddressGlobalKey.currentState!.validate() != true) {
      return;
    }

    UserAddress userAddress = UserAddress();
    userAddress.id = editUserAddress != null ? editUserAddress?.id : 0;
    userAddress.isValidated = true;
    userAddress.overrideValidation = false;

    userAddress.isDefault = isDefaultAddress;
    userAddress.firstName = firstNameFormFieldController.text;
    userAddress.lastName = lastNameFormFieldController.text;
    userAddress.company = companyFormFieldController.text;
    userAddress.add1 = streetTextEditingController.text;
    userAddress.add2 = streetTextEditingController.text;
    userAddress.city = cityFormFieldController.text;
    userAddress.country = countryFormFieldController.text;
    userAddress.state = stateFormFieldController.text;
    userAddress.zip = pinFormFieldController.text;
    userAddress.primaryPhone = phoneFormFieldController.text;

    setBusyForObject(loading, true);
    ShippingAddress? response = await request<ShippingAddress>(AddressRequest.addAddress(userAddress.toJson()));
    setBusyForObject(loading, false);
    if (response != null) {
      _shippingAddress = response;
      notifyListeners();

      if (_shippingAddress?.recommendedAddress == null) {
        navigationService.pop(returnValue: _shippingAddress!.address!.id);
        return;
      }

      if (_shippingAddress!.recommendedAddress != null) {
        AlertResponse alertResponse = await locator<DialogService>()
            .showBottomSheet(
            title: "Verify Shipping Address",
            child: AddressRecommendBottomSheet(this),
            showCloseIcon: false);
        if (alertResponse.status != true) {
          return;
        }
        navigationService.pop(returnValue: alertResponse.data as int);
      }
    }
  }


  void showCountries() async {
    searchController.clear();
    AlertResponse response = await locator<DialogService>().showBottomSheet(title: "Select Country", child: SelectCountryStateBottomSheet(_shippingAddress, true), showActionBar: true);

    if (response.data != null) {
      setBusy(true);

      countryFormFieldController.text = response.data.text;
      stateFormFieldController.clear();

      shippingAddress?.availableStates = await requestList<SelectedItemList>(AddressRequest.getAvailableStates(response.data.value));

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
    AlertResponse response = await locator<DialogService>().showBottomSheet(title: "Select State", child: SelectCountryStateBottomSheet(_shippingAddress, false), showActionBar: true);

    if (response.data != null) {
      stateFormFieldController.text = response.data.text;
      pinFormFieldController.focusNode.requestFocus();
    }
  }

  onStreetNameSelect(Predictions predictions) async {
    setBusy(true);

    streetTextEditingController.text = predictions.structuredFormatting!.mainText!;

    Place? place = await googlePlaceApi!.getPlaceInfoFromPlaceId(predictions.placeId);

    List<AddressComponents> addressComponent = place!.result!.addressComponents!;

    AddressComponents? city = addressComponent.firstWhereOrNull((element) => element.types!.contains("locality"));
    cityFormFieldController.text = city == null ? '' : city.longName!;

    AddressComponents? country = addressComponent.firstWhereOrNull((element) => element.types!.contains("country"));
    if (country != null) {
      SelectedItemList? data = _shippingAddress!.availableCountries!.singleWhereOrNull((element) => element.value == country.shortName || element.value!.toLowerCase() == country.longName!.toLowerCase());
      countryFormFieldController.text = data == null ? '' : data.text!;

      AddressComponents? state = addressComponent.firstWhereOrNull((element) => element.types!.contains("administrative_area_level_1"));
      if (state != null && data != null) {
        _shippingAddress!.availableStates = await requestList(AddressRequest.getAvailableStates(data.value!));

        if (_shippingAddress!.availableStates!.isEmpty) {
          stateFormFieldController.text = state.longName!;
        } else {
          SelectedItemList? stateData = _shippingAddress!.availableStates!.singleWhereOrNull((element) => element.value == state.shortName);
          stateFormFieldController.text = stateData == null ? '' : stateData.text!;
        }
      }
    }

    String? pinCode = '';
    AddressComponents? pincode = addressComponent.firstWhereOrNull((element) => element.types!.contains("postal_code"));
    pinCode = pincode == null ? '' : pincode.shortName!;

    AddressComponents? pinCodeSuffix = addressComponent.firstWhereOrNull((element) => element.types!.contains("postal_code_suffix"));
    pinCode += pinCodeSuffix == null ? '' : '-${pinCodeSuffix.shortName}';

    pinFormFieldController.text = pinCode;

    setBusy(false);
  }

  saveRecommended() async {
    shippingAddress!.recommendedAddress!.id = shippingAddress!.address!.id;

    setBusy(true);

    List<UserAddress> recommendedAddress = await requestList<UserAddress>(AddressRequest.saveRecommended(
        _selectedAddress == SelectAddress.Suggested
            ? shippingAddress!.recommendedAddress!
            : shippingAddress!.address!)) ?? [];
    setBusy(false);
    locator<DialogService>().dialogComplete(AlertResponse(status: true, data: recommendedAddress.first.id));
    notifyListeners();
  }

}
