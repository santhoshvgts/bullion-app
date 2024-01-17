import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/services/api_request/address_request.dart';

import '../vgts_base_view_model.dart';

class AddressViewModel extends VGTSBaseViewModel {
  List<UserAddress>? _userAddressList;
  UserAddress? _defaultAddress;
  bool _hasNoData = false;

  int? _selectedAddressId;
  int? get selectedAddressId => _selectedAddressId;

  set selectedAddressId(int? value) {
    _selectedAddressId = value;
    // if (value != 0) {
    //   _selectedType = AddressTypeCard.;
    // }
    notifyListeners();
  }

  init() {
    getAddressData();
  }

  void getAddressData() async {
    setBusy(true);

    _userAddressList = await requestList<UserAddress>(AddressRequest.getAddress());

    if (_userAddressList != null) getDefaultAddress();
    if ((_userAddressList == null || _userAddressList!.isEmpty) && _defaultAddress == null) _hasNoData = true;

    setBusy(false);
  }

  List<UserAddress>? get userAddress => _userAddressList;

  void getDefaultAddress() {
    for (int i = 0; i < _userAddressList!.length; i++) {
      if (_userAddressList![i].isDefault == true) {
        _defaultAddress = _userAddressList![i];
        _userAddressList?.removeAt(i);
      }
    }
  }

  void deleteAddress(int addressId) async {
    setBusy(true);

    _userAddressList = await requestList<UserAddress>(AddressRequest.deleteAddress(addressId));

    if (_userAddressList != null) getDefaultAddress();

    setBusy(false);
  }

  onAddressSelect(UserAddress address) {
    selectedAddressId = address.id;
    navigationService.pop(returnValue: userAddressList?.singleWhere((element) => element.id == selectedAddressId));
  }

  List<UserAddress>? get userAddressList => _userAddressList;

  UserAddress? get defaultAddress => _defaultAddress;

  bool get hasNoData => _hasNoData;
}
