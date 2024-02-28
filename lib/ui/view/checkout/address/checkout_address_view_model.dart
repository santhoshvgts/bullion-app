
import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/api_request/address_request.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

import '../../../../services/api_request/checkout_request.dart';

class CheckoutAddressViewModel extends VGTSBaseViewModel {

  List<UserAddress>? _userAddressList;

  List<UserAddress> get userAddressList => _userAddressList ?? [];

  @override
  Future onInit() async {
    fetchAddress();
    super.onInit();
  }

  fetchAddress() async {
    setBusy(true);
    _userAddressList = await requestList<UserAddress>(AddressRequest.getAddress());
    setBusy(false);
  }

  onEditAddress(UserAddress userAddress) async {
    var result = await navigationService.pushNamed(Routes.addEditAddress, arguments: { "fromCheckout": true, "userAddress": userAddress });
    if (result != null) {
      onSelectShippingAddress(result);
    }
  }

  onSelectShippingAddress(int addressId) async {
    setBusy(true);
    await locator<CheckoutStreamService>().saveAddressAndRefreshCheckout(addressId);
    setBusy(false);
  }

  addAddress() async {
    int? result = await navigationService.pushNamed(Routes.addEditAddress, arguments: { "fromCheckout": true });
    if (result != null) {
      onSelectShippingAddress(result);
    }
  }
}