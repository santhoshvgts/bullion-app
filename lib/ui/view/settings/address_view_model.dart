import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/services/api_request/address_request.dart';

import '../vgts_base_view_model.dart';

class AddressViewModel extends VGTSBaseViewModel {

  List<UserAddress>? _userAddressList;

  List<UserAddress> get userAddressList => _userAddressList ?? [];

  @override
  Future onInit() async {
    setBusy(true);
    _userAddressList = await requestList<UserAddress>(AddressRequest.getAddress());
    setBusy(false);
    super.onInit();
  }

  void deleteAddress(int addressId) async {
    setBusy(true);
    _userAddressList = await requestList<UserAddress>(AddressRequest.deleteAddress(addressId));
    setBusy(false);
  }

  onAddressSelect(UserAddress address) {
    navigationService.pop(returnValue: address);
  }

}
