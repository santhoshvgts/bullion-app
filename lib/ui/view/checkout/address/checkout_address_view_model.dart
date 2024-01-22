
import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/address_request.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

import '../../../../services/api_request/checkout_request.dart';

class CheckoutAddressViewModel extends VGTSBaseViewModel {

  List<UserAddress>? _userAddressList;

  List<UserAddress> get userAddressList => _userAddressList ?? [];

  @override
  Future onInit() async {
    setBusy(true);
    _userAddressList = await requestList<UserAddress>(AddressRequest.getAddress());
    setBusy(false);
    super.onInit();
  }

  onSelectShippingAddress(UserAddress userAddress) async {
    setBusy(true);
    await locator<CheckoutStreamService>().saveAddressAndRefreshCheckout(userAddress);
    setBusy(false);
  }

}