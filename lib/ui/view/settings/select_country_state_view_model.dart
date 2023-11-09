import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import '../../../core/models/module/checkout/shipping_address.dart';
import '../../../core/models/module/selected_item_list.dart';

class SelectCountryStateViewModel extends VGTSBaseViewModel {

  ShippingAddress? _shippingAddress;

  TextEditingController searchController  = TextEditingController();

  FocusNode searchFocus = FocusNode();

  void init(ShippingAddress? shippingAddress) {
    _shippingAddress = shippingAddress;
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

}