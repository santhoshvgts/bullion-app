import 'dart:async';
import 'package:bullion/core/models/module/dynamic.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/services/api_request/checkout_request.dart';
import 'package:bullion/services/payment/bitpay_service.dart';
import 'package:bullion/services/payment/braintree_service.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/core/models/module/checkout/selected_payment_method.dart';
import 'package:bullion/core/models/module/checkout/shipping_option.dart';
import 'package:bullion/core/models/module/order.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import '../../../../helper/utils.dart';

class CheckoutViewModel extends VGTSBaseViewModel {

  String errorText = "";

  bool _showAddressSelection = false;
  bool _showPaymentSelection = false;

  bool get showPaymentSelection => _showPaymentSelection;

  set showPaymentSelection(bool value) {
    _showPaymentSelection = value;
    notifyListeners();
  }

  bool get showAddressSelection => _showAddressSelection;

  set showAddressSelection(bool value) {
    _showAddressSelection = value;
    notifyListeners();
  }

  final CheckoutStreamService _checkoutStreamService = locator<CheckoutStreamService>();

  String get formattedRemainingPricingTime =>
      _countDownTxt == "" ? "-" : _countDownTxt;

  Checkout? _checkout;

  Checkout? get checkout => _checkout;

  set checkout(Checkout? value) {
    _checkout = value;
    if (_checkout?.redirect == true) {
      switch (_checkout!.redirectUrl) {
        case "/cart":
        default:
          navigationService.pushReplacementNamed(
            Routes.viewCart,
            arguments: _checkout!.displayMessage,
          );
          break;
      }
    }
  }

  SelectedPaymentMethod? get paymentMethod => _checkout!.selectedPaymentMethod;

  List<OrderTotalSummary>? get orderSummaryList =>
      _checkout == null ? [] : _checkout!.orderTotalSummary;

  bool _placeOrderLoading = false;

  bool _lockedOut = false;
  String _countDownTxt = "";
  int _countDownValue = 0;

  Timer? timer;

  Order? _orderResponse;

  Order? get orderResponse => _orderResponse;

  bool get placeOrderLoading => _placeOrderLoading;

  set placeOrderLoading(bool value) {
    _placeOrderLoading = value;
    notifyListeners();
  }

  bool get enablePlaceOrder {
    if (checkout == null) return false;

    if (checkout!.selectedShippingAddress == null) return false;

    if (checkout!.selectedPaymentMethod == null) return false;

    return true;
  }

  bool _mounted = true;

  bool get mounted => _mounted;

  set mounted(bool value) {
    _mounted = value;

    if (_mounted && _lockedOut) {
      _lockedOut = false;
      navigationService.pushReplacementNamed(Routes.expiredCart,
          arguments: true);
    }
    notifyListeners();
  }

  init() async {
    await loadCheckout();
    _runCountdown(_checkout!.timerDuration!);
    _checkoutStreamService.stream?.listen((event) {
      checkout = event;
      showPaymentSelection = false;
      showAddressSelection = false;
      notifyListeners();
    });

    var cart = await (locator<CartService>().getCart());

    locator<AnalyticsService>().logBeginCheckout(cart?.shoppingCart);
  }

  refreshPage() async {
    if (timer != null) {
      print("TIMER DISPOSE IN REFRESH");
      timer!.cancel();
      timer = null;

      setBusy(true);
      checkout = await request<Checkout>(CheckoutRequest.validatePrice());
      _runCountdown(_checkout!.timerDuration!);
      setBusy(false);
    }
  }

  @override
  void dispose() {
    print("onDispose");
    if (timer != null) {
      print("TIMER DISPOSE");
      timer!.cancel();
      timer = null;
    }

    super.dispose();
  }

  loadCheckout() async {
    setBusy(true);
    checkout = await request<Checkout>(CheckoutRequest.getCheckout());
    setBusy(false);
  }

  onDeliveryAddressSelection() async {
    showAddressSelection = true;
  }

  onPaymentClick() async {
    showPaymentSelection = true;
  }

  onShippingOptionSelect(ShippingOption shippingOption) async {
    setBusy(true);
    checkout = await request<Checkout>(CheckoutRequest.saveShippingOption(
        shippingId: shippingOption.id, shipCharge: shippingOption.shipCharge));
    setBusy(false);

    try {
      locator<AnalyticsService>().logShippingAddressInfo(
          cartItem: locator<CartService>().cartItems,
          currency: "USD",
          coupon: "",
          orderTotal: checkout?.orderTotal,
          shippingTier: checkout?.selectedShippingOption?.shippingOptions?.singleWhere((element) => element.id == checkout?.selectedShippingOption?.selectedShippingOption).name
      );
    } catch (ex, s) {
      Logger.e(ex.toString(), s: s);
    }
  }

  // Payment & Place Order
  onPayPalClick() async {
    if (placeOrderLoading) {
      return;
    }

    mounted = false;
    placeOrderLoading = true;
    Util.cancelLockEvent();
    var response = await BraintreeService().openPayPal(checkout!.orderTotal);
    placeOrderLoading = false;
    mounted = true;
    Util.enableLockEvent();

    if (response['nonce'] != null) {
      submitPlaceOrder(paymentMethodNonce: response['nonce']);
    }
  }

  onBitPayClick() async {
    if (placeOrderLoading) {
      return;
    }

    mounted = false;
    placeOrderLoading = true;
    Util.cancelLockEvent();
    var response = await BitPayService().openBitPayPayment();
    placeOrderLoading = false;
    mounted = true;
    Util.enableLockEvent();

    if (response == true) {
      submitPlaceOrder();
    }
  }

  submitPlaceOrder({String? paymentMethodNonce, String? paymentMethodDeviceData}) async {
    mounted = false;

    placeOrderLoading = true;
    debugPrint("Nonce $paymentMethodNonce");
    var response = (await request<DynamicModel>(CheckoutRequest.placeOrder(
        _checkout!.selectedShippingAddress,
        _checkout!.selectedPaymentMethod,
        paymentMethodNonce,
        paymentMethodDeviceData)))?.json;
    placeOrderLoading = false;

    if (response == null) {
      mounted = true;
      return;
    }

    var placeOrderResponse = response.containsKey("order_id") ? Order.fromJson(response) : Checkout.fromJson(response);

    if (placeOrderResponse is Checkout) {
      checkout = placeOrderResponse;
      return;
    }

    placeOrderResponse = placeOrderResponse as Order;

    if (placeOrderResponse.orderId != null) {
      locator<CartService>().clear();

      switch (placeOrderResponse.customerType) {
       case "new":
          locator<AnalyticsService>().logEvent('new_customer_order', {
            'transaction_id': placeOrderResponse.orderId,
            'value': placeOrderResponse.predictiveMargin
          });
          locator<AnalyticsService>().logFirstPurchase(placeOrderResponse);
          break;
        case "returning":
          locator<AnalyticsService>().logEvent('returning_customer_order', {
            'transaction_id': placeOrderResponse.orderId,
            'value': placeOrderResponse.predictiveMargin
          });
          break;
      }

      locator<AnalyticsService>().logPurchase(placeOrderResponse);
      locator<EventBusService>().eventBus.fire(CartRefreshEvent());

      navigationService.pushAndPopUntil(
        "${Routes.orderPlaced}/${placeOrderResponse.orderId}",
        removeRouteName: Routes.dashboard,
      );
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

  Future<void> _runCountdown(int count) async {
    if (count > 0) {
      print("TIMER CREATE");
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted && count <= 1) {
          navigationService.pushReplacementNamed(Routes.expiredCart,
              arguments: true);
          timer.cancel();
          return;
        } else if (count <= 1) {
          _lockedOut = true;
          timer.cancel();
          return;
        }

        _lockedOut = false;
        _countDownValue = count;
        _countDownTxt = _formatCountDisplay(count);
        notifyListeners();
        count--;
      });
    }
  }

  onRemoveFromOrderSummary(String? keyCode) async {
    if (isBusy) {
      return;
    }
    setBusy(true);
    var response = await request<Checkout>(CheckoutRequest.removeDiscountByKey(keyCode));
    if (response != null) {
      checkout = response;
    }
    setBusy(false);
  }

}
