import 'dart:async';

import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/cart/shopping_cart.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/shared/sign_in_request.dart';
import 'package:bullion/services/toast_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import 'display_message_toast.dart';

class CartViewModel extends VGTSBaseViewModel {
  final ToastService toastService = locator<ToastService>();
  final DialogService dialogService = locator<DialogService>();

  TextFormFieldController promoCodeController = TextFormFieldController(const ValueKey("txtPromoCode"),);
  Timer? debounce;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool promoCodeValidate = false;

  String? errorText;

  final CartService _cartService = locator<CartService>();

  PageSettings? _cart;

  PageSettings? get cart => _cart;

  List<ModuleSettings?>? get modules => cart == null ? [] : cart!.moduleSetting;

  ShoppingCart? get shoppingCart => cart?.shoppingCart;

  List<CartItem>? get cartItems =>
      shoppingCart == null ? [] : shoppingCart!.items;

  List<OrderTotalSummary>? get orderSummary => shoppingCart?.orderTotalSummary;

  int? get totalItems => shoppingCart == null ? 0 : shoppingCart!.totalItems;

  DisplayMessage? get inlineMessage {
    if (_cart == null) {
      return null;
    }
    if (_cart?.displayMessage == null) {
      return null;
    }
    return _cart?.displayMessage?.messageDisplayType ==
            MessageDisplayType.Inline
        ? _cart?.displayMessage
        : null;
  }

  DisplayMessage? _couponInlineMessage;

  DisplayMessage? get couponInlineMessage => _couponInlineMessage;

  set couponInlineMessage(DisplayMessage? value) {
    _couponInlineMessage = value;
    notifyListeners();
  }

  init(bool fromMain) async {
    _cart = await _cartService.getCart();
    notifyListeners();

    if (fromMain) {
      locator<EventBusService>().eventBus.registerTo<CartRefreshEvent>().listen((event) async {
        setBusy(true);
        await refresh();
        setBusy(false);
      });
    }


    setBusy(true);
    await refresh();
    setBusy(false);
  }

  modifyItemQty(CartItem product, int qty) async {
    if (qty == 0) {
      removeItem(product);
      return;
    }

    if (isBusy) return;

    setBusy(true);
    _cart = await _cartService.modifyItem(product.productId, qty);
    setBusy(false);

    locator<AnalyticsService>().logAddToCart(
        itemId: product.productId.toString(),
        itemName: product.productName ?? '',
        price: product.unitPrice,
        value: qty * product.unitPrice!,
        quantity: qty,
        currency: 'USD',
        itemCategory: '');

    if (_cart?.displayMessage != null) displayMessage(_cart?.displayMessage);
  }

  removeItem(CartItem product) async {
    if (isBusy) return;

    setBusy(true);

    _cart = await _cartService.removeItemFromCart(product.productId);

    //TODO Analytics
    locator<AnalyticsService>().removeFromCart(
      itemId: product.productId.toString(),
      itemName: product.productName ?? '',
      itemCategory: '',
      quantity: product.quantity ?? 0,
      value: product.unitPrice! * product.quantity!,
      price: product.unitPrice,
      currency: 'USD',
    );

    setBusy(false);

    if (_cart?.displayMessage != null) displayMessage(_cart?.displayMessage);
  }

  applyCoupon(BuildContext context) async {
    setBusyForObject(promoCodeController, true);

    PageSettings? settings =
        await _cartService.applyCoupon(promoCodeController.text);

    if (settings != null) {
      if (settings.isSuccess == false) {
        _couponInlineMessage = settings.displayMessage;
        notifyListeners();
      } else {
        _cart = settings;
        displayMessage(_cart?.displayMessage);
        Navigator.pop(context);
      }
    }
    setBusyForObject(promoCodeController, false);

    return;
  }

  displayMessage(DisplayMessage? displayMessage) async {
    if (displayMessage == null) return;

    String? displayType = displayMessage.messageDisplayType;

    if (displayType == MessageDisplayType.SnackBar) {
      toastService.showWidget(child: DisplayMessageToast(displayMessage), durationInSeconds: 5);
      return;
    }

    if (displayType == MessageDisplayType.BottomSheet) {
      await dialogService.showBottomSheet(
          title: displayMessage.title ?? '',
          showActionBar: false,
          child: DisplayMessageBottomSheet(displayMessage));
      return;
    }

    if (displayType == MessageDisplayType.AlertBox) {
      await dialogService.displayMessage(
          title: displayMessage.title ?? '',
          showActionBar: false,
          child: DisplayMessageBottomSheet(displayMessage));
      return;
    }
  }

  onCheckoutClick() async {
    if (!locator<AuthenticationService>().isAuthenticated) {
      bool authenticated = await signInRequest(Images.iconCartBottom,
          title: "Checkout",
          content:
          "Login or Create a free BULLION.com account for fast checkout and easy access to order history.",
          showGuestLogin: true);
      if (!authenticated) return;
    }

    locator<NavigationService>().pushNamed(Routes.checkout)!.then((value) {
      setBusy(true);
      refresh();
      setBusy(false);
    });
  }

  refresh() async {
    _cart = await _cartService.getCart(refresh: true);

    locator<AnalyticsService>().logEvent('view_cart', {
      'currency': 'USD',
      'value': shoppingCart?.orderTotal,
      'items': shoppingCart?.items
          ?.map((e) => {
                'item_id': e.productId,
                'price': e.unitPrice,
                'quantity': e.quantity
              })
          .toList()
          .toString()
    });

    if (_cart?.displayMessage != null) displayMessage(_cart?.displayMessage);

    notifyListeners();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
}
