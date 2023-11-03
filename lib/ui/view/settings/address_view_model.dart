import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/services/api_request/address_request.dart';

import '../vgts_base_view_model.dart';

class AddressViewModel extends VGTSBaseViewModel {
  List<UserAddress>? _userAddressList;
  UserAddress? _defaultAddress;

  init() {
    getAddressData();
  }

  void getAddressData() async {
    setBusy(true);

    _userAddressList = await requestList<UserAddress>(AddressRequest.getAddress());

    if(_userAddressList != null) getDefaultAddress();

    setBusy(false);
  }

  List<UserAddress>? get userAddress => _userAddressList;

  void getDefaultAddress() {
    for(int i = 0; i < _userAddressList!.length; i++) {
      if (_userAddressList![i].isDefault == true) {
        _defaultAddress = _userAddressList![i];
        _userAddressList?.removeAt(i);
      }
    }
  }

  List<UserAddress>? get userAddressList => _userAddressList;

  UserAddress? get defaultAddress => _defaultAddress;
}