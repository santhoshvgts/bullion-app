import 'dart:async';

import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/models/module/checkout/selected_payment_method.dart';
import 'package:bullion/core/models/module/checkout/shipping_option.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/api_request/checkout_request.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckoutPageViewModel extends VGTSBaseViewModel {
  //************************************/ ( INITIALIZATION )

  Checkout? _checkout;
  Timer? timer;
  final ApiBaseService _apiBaseService = locator<ApiBaseService>();
  List<PaymentMethod>? _paymentMethodList;
  final CheckoutStreamService _checkoutStreamService = CheckoutStreamService();

  //************************************/ ( LOCAL VARIABLES )

  String _countDownTxt = "";
  bool _lockedOut = false;
  bool _mounted = true;
  bool _placeOrderLoading = false;
  List<PaymentMethod>? enabledpaymentMethodList = [];

  //************************************/ ( GETTER )

  Checkout? get checkout => _checkout;
  SelectedPaymentMethod? get paymentMethod => _checkout!.selectedPaymentMethod;
  List<OrderTotalSummary>? get orderSummaryList => _checkout == null ? [] : _checkout!.orderTotalSummary;
  String get formattedRemainingPricingTime => _countDownTxt == "" ? "-" : _countDownTxt;
  bool get mounted => _mounted;
  bool get placeOrderLoading => _placeOrderLoading;
  List<PaymentMethod>? get paymentMethodList => _paymentMethodList ?? [];

  bool get enablePlaceOrder {
    if (checkout == null) return false;
    if (checkout!.selectedShippingAddress == null) return false;
    if (checkout!.selectedPaymentMethod == null) return false;
    return true;
  }

  //************************************/ ( INIT FUNCTION )

  @override
  onInit() async {
    await loadCheckout();
    await fetchPayments();
    _runCountdown(_checkout!.timerDuration!);
    //! _checkoutStreamService!.stream?.listen((event) {
    //!   checkout = event;
    //!   notifyListeners();
    //! });

    var cart = await (locator<CartService>().getCart());

    //!locator<AnalyticsService>().logBeginCheckout(cart?.shoppingCart);
    return super.onInit();
  }

  //************************************/ ( SETTER )

  set checkout(Checkout? value) {
    _checkout = value;
    if (_checkout?.redirect == true) {
      switch (_checkout!.redirectUrl) {
        case "/cart":
        default:
          navigationService.pushReplacementNamed(Routes.viewCart, arguments: _checkout!.displayMessage);
          break;
      }
    }
  }

  set mounted(bool value) {
    _mounted = value;
    if (_mounted && _lockedOut) {
      _lockedOut = false;
      navigationService.pushReplacementNamed(Routes.expiredCart, arguments: true);
    }
    notifyListeners();
  }

  set placeOrderLoading(bool value) {
    _placeOrderLoading = value;
    notifyListeners();
  }

  //************************************/ ( Page Refresh  )

  refreshPage() async {
    if (timer != null) {
      debugPrint("TIMER DISPOSE IN REFRESH");
      timer!.cancel();
      timer = null;
      setBusy(true);
      checkout = await _apiBaseService.request<Checkout>(CheckOutRequest.validatePrice());
      _runCountdown(_checkout!.timerDuration!);
      setBusy(false);
    }
  }

  //************************************/ ( Load CHECKOUT )

  loadCheckout() async {
    setBusy(true);
    checkout = await _apiBaseService.request<Checkout>(CheckOutRequest.getCheckout());
    setBusy(false);
  }

  //************************************/! ( Get Payments )

  fetchPayments() async {
    setBusy(true);
    _paymentMethodList = await _apiBaseService.requestList<PaymentMethod>(CheckOutRequest.getPaymentMethods());
    setBusy(false);
  }

  //************************************/! ( DELIVERY ADDRESS )

  onShippingOptionSelect(ShippingOption shippingOption) async {
    setBusy(true);
    checkout = await _apiBaseService.request<Checkout>(CheckOutRequest.saveShippingOption(shippingId: shippingOption.id, shipCharge: shippingOption.shipCharge));
    setBusy(false);
  }

  //************************************/! ( paymentSelection )

  // onDeliveryAddressSelection() async {
  //   mounted = false;
  //   var address = await navigationService.pushNamed(Routes.checkoutAddress);
  //   mounted = true;

  //   print("Address $address");

  //   if (address == true) {
  //     refreshPage();
  //     return;
  //   }

  //   if (address != null) {
  //     print("ADDRESS $address");
  //     int? addressId;
  //     bool? isCitadel;
  //     String? citadelAccount;

  //     if (address is UserAddress) {
  //       addressId = address.id;
  //       isCitadel = false;
  //     } else if (address is String) {
  //       addressId = 0;
  //       isCitadel = true;
  //       citadelAccount = address;
  //     }

  //     setBusy(true);
  //     checkout = await _apiBaseService.request<Checkout>(CheckOutRequest.saveDeliveryAddress(addressId: addressId, isCitadel: isCitadel, citadelAccount: citadelAccount));

  //     setBusy(false);
  //   }
  // }

  //************************************/! ( paymentSelection )

  paymentSelection(PaymentMethod payment) async {
    for (var p in _paymentMethodList!) {
      if (p.paymentMethodId == payment.paymentMethodId) {
        p.canExpanded = !p.canExpanded!;
        p.isSelected = !p.isSelected!;
      } else {
        p.canExpanded = false;
        p.isSelected = false;
      }
    }
    Util.cancelLockEvent();
    if (!payment.supportsUserPaymentMethod! && !payment.requiresZda!) {
      await savePaymentMethod(payment.paymentMethodId, userPaymentMethodId: payment.userPaymentMethodId);
    } else {
      if (payment.hasUserPaymentMethod! || payment.requiresZda!) {
        // AlertResponse alertResponse = await locator<DialogService>().showBottomSheet(
        //   key: const ValueKey("bsUserPaymentMethod"),
        //   title: payment.name,
        //   isDismissible: false,
        //   child: UserPaymentMethodBottomSheet(
        //     paymentMethod,
        //     payment.userPaymentMethods,
        //   ),
        // );
        // if (alertResponse.status == true && alertResponse.data == "REMOVE_PAYMENT") {
        //   fetchPayments();
        //   return;
        // }
      } else {
        switch (payment.paymentMethodId) {
          // case 19: // eCheck
          //   await _addECheckBankInformation(paymentMethod);
          //   break;
          case 1: // Credit Card
            // await _creditCardPage(paymentMethod);
            await savePaymentMethod(payment.paymentMethodId, userPaymentMethodId: payment.userPaymentMethodId);
            break;
          default:
            break;
        }
        return;
      }
    }
    notifyListeners();
  }

  //************************************/! ( SavePaymentMethod )

  Future<Checkout?> savePaymentMethod(int? paymentMethodId, {int? userPaymentMethodId}) async {
    mounted = false;
    setBusy(true);
    var response = await _checkoutStreamService.savePaymentAndRefreshCheckout(paymentMethodId, userPaymentMethodId: userPaymentMethodId ?? 0);
    setBusy(false);
    mounted = false;
    refreshPage();
    return response;
  }

//************************************/! ( PAYPAL )
  onPayPalClick() async {
    if (placeOrderLoading) {
      return;
    }

    mounted = false;
    placeOrderLoading = true;
    Util.cancelLockEvent();
    //! var response = await BraintreeService().openPayPal(checkout!.orderTotal);
    placeOrderLoading = false;
    mounted = true;
    Util.enableLockEvent();

    //! if (response['nonce'] != null) {
    //   submitPlaceOrder(paymentMethodNonce: response['nonce']);
    // }
  }

  //************************************/! ( BITPAY )

  onBitPayClick() async {
    if (placeOrderLoading) {
      return;
    }

    mounted = false;
    placeOrderLoading = true;
    Util.cancelLockEvent();
    //! var response = await BitPayService().openBitPayPayment();
    placeOrderLoading = false;
    mounted = true;
    Util.enableLockEvent();

    //! if (response == true) {
    //!   submitPlaceOrder();
    //! }
  }

  //************************************/! ( PAYMNET )

  submitPlaceOrder({String? paymentMethodNonce, String? paymentMethodDeviceData}) async {
    mounted = false;

    placeOrderLoading = true;
    debugPrint("Nonce $paymentMethodNonce");
    // var placeOrderResponse = await _checkoutApi!.placeOrder(_checkout!.selectedShippingAddress, _checkout!.selectedPaymentMethod, paymentMethodNonce, paymentMethodDeviceData);
    // placeOrderLoading = false;

    // if (placeOrderResponse == null) {
    //   mounted = true;
    //   return;
    // }

    // if (placeOrderResponse is Checkout) {
    //   checkout = placeOrderResponse;
    //   return;
    // }

    // if (placeOrderResponse.orderId != null) {
    //   locator<CartService>().clear();

    //   switch (placeOrderResponse.customerType) {
    //     case "new":
    //       locator<AnalyticsService>().logEvent('new_customer_order', {'transaction_id': placeOrderResponse.orderId, 'value': placeOrderResponse.predictiveMargin});
    //       //! locator<AnalyticsService>().logFirstPurchase(placeOrderResponse);
    //       break;
    //     case "returning":
    //       locator<AnalyticsService>().logEvent('returning_customer_order', {'transaction_id': placeOrderResponse.orderId, 'value': placeOrderResponse.predictiveMargin});
    //       break;
    //   }

    // //! locator<AnalyticsService>().logPurchase(placeOrderResponse);

    // navigationService.pushAndPopUntil(
    //   "${Routes.orderPlaced}/${placeOrderResponse.orderId}",
    //   removeRouteName: Routes.dashboard,
    // );
    //  }
  }

  //************************************/! ( DELIVERY ADDRESS )

  onDeliveryAddressSelection() async {
    mounted = false;
    var address = await navigationService.pushNamed(Routes.address);
    mounted = true;

    debugPrint("Address $address");

    if (address == true) {
      refreshPage();
      return;
    }

    if (address != null) {
      debugPrint("ADDRESS $address");
      int? addressId;
      bool? isCitadel;
      String? citadelAccount;

      if (address is UserAddress) {
        addressId = address.id;
        isCitadel = false;
      } else if (address is String) {
        addressId = 0;
        isCitadel = true;
        citadelAccount = address;
      }

      setBusy(true);
      checkout = await _apiBaseService.request<Checkout>(CheckOutRequest.saveDeliveryAddress(addressId: addressId, isCitadel: isCitadel, citadelAccount: citadelAccount));
      setBusy(false);
    }
  }

  //************************************/ ( TIMER LOGIC  )

  Future<void> _runCountdown(int count) async {
    if (count > 0) {
      debugPrint('TIMER CREATE');

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted && count <= 1) {
          navigationService.pop();

          //! TODO : review cart 
          // navigationService.pushReplacementNamed(Routes.viewCart,
          //     arguments: DisplayMessage(
          //       message: 'Cart expired',
          //     ));
          timer.cancel();
          return;
        } else if (count <= 1) {
          _lockedOut = true;
          timer.cancel();
          return;
        }

        _lockedOut = false;
        _countDownTxt = _formatCountDisplay(count);
        notifyListeners();
        count--;
      });
    }
  }

  String _formatCountDisplay(int count) {
    if (count <= 60) {
      // Seconds only
      String secondsStr = count.toString();
      if (count < 10) {
        secondsStr = "0$secondsStr";
      }
      return "00:$secondsStr";
    } else if (count > 60 && count <= 3600) {
      // Minutes:Seconds
      String minutesStr = "";
      int minutes = count ~/ 60;
      if (minutes < 10) {
        minutesStr = "0$minutes";
      } else {
        minutesStr = minutes.toString();
      }
      String secondsStr = "";
      int seconds = count % 60;
      if (seconds < 10) {
        secondsStr = "0$seconds";
      } else {
        secondsStr = seconds.toString();
      }
      return "$minutesStr:$secondsStr";
    } else {
      // Hours:Minutes:Seconds
      String hoursStr = "";
      int hours = count ~/ 3600;
      if (hours < 10) {
        hoursStr = "0$hours";
      } else {
        hoursStr = hours.toString();
      }
      count = count % 3600;
      String minutesStr = "";
      int minutes = count ~/ 60;
      if (minutes < 10) {
        minutesStr = "0$minutes";
      } else {
        minutesStr = minutes.toString();
      }
      String secondsStr = "";
      int seconds = count % 60;
      if (seconds < 10) {
        secondsStr = "0$seconds";
      } else {
        secondsStr = seconds.toString();
      }
      return "$hoursStr:$minutesStr:$secondsStr";
    }
  }

  //************************************/ ( DISPOSE  )
  @override
  void dispose() {
    debugPrint("onDispose");
    if (timer != null) {
      debugPrint("TIMER DISPOSE");
      timer!.cancel();
      timer = null;
    }
    super.dispose();
  }

//************************************/ ( RemoveFromOrder  )

  onRemoveFromOrderSummary(String? keyCode) async {
    if (isBusy) {
      return;
    }
    setBusy(true);

    var response = await _apiBaseService.request<Checkout>(CheckOutRequest.removeDiscountByKey(keyCode));
    checkout = response;
    setBusy(false);
  }

//************************************/ ( PaymentIcons  )

  IconData paymentFAIcon(String? name) {
    switch (name) {
      case "fa fa-exchange-alt":
        return FontAwesomeIcons.rightLeft;
      case "fa fa-credit-card":
        return FontAwesomeIcons.solidCreditCard;
      case "fab fa-paypal":
        return FontAwesomeIcons.paypal;
      case "fa fa-university":
        return FontAwesomeIcons.buildingColumns;
      case "fab fa-cc-visa":
        return FontAwesomeIcons.ccVisa;
      case "fab fa-cc-mastercard":
        return FontAwesomeIcons.ccMastercard;
      case "fa fa-money-check":
        return FontAwesomeIcons.moneyCheck;
      case "fa fa-wallet":
        return FontAwesomeIcons.wallet;
      case "fa fa-chart-line":
        return FontAwesomeIcons.chartLine;
      case "fa fa-newspaper":
        return FontAwesomeIcons.newspaper;
      case "fab fa-bitcoin":
        return FontAwesomeIcons.bitcoin;
      case "fa fa-piggy-bank":
        return FontAwesomeIcons.piggyBank;
      default:
        return FontAwesomeIcons.circle;
    }
  }

  Color paymentFAIconColor(String? name) {
    switch (name) {
      case "fa fa-exchange-alt":
        return AppColor.green;
      case "fa fa-credit-card":
        return AppColor.green;
      case "fab fa-paypal":
        return const Color(0xFF023087);
      case "fa fa-university":
        return AppColor.green;
      case "fab fa-cc-visa":
        return AppColor.green;
      case "fab fa-cc-mastercard":
        return AppColor.green;
      case "fa fa-money-check":
        return AppColor.green;
      case "fa fa-wallet":
        return AppColor.green;
      case "fa fa-chart-line":
        return AppColor.green;
      case "fa fa-newspaper":
        return AppColor.green;
      case "fab fa-bitcoin":
        return const Color(0xFF022147);
      case "fa fa-piggy-bank":
        return AppColor.green;
      default:
        return AppColor.green;
    }
  }
}
