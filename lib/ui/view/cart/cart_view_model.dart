import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/cart/shopping_cart.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/toast_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import 'display_message_toast.dart';

class CartViewModel extends VGTSBaseViewModel {
  final ToastService toastService = locator<ToastService>();
  final DialogService dialogService = locator<DialogService>();

  TextEditingController promoCodeController = TextEditingController();
  FocusNode promoCodeFocus = FocusNode();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool promoCodeValidate = false;

  String? errorText;

  final CartService _cartService = locator<CartService>();

  PageSettings? _cart;

  PageSettings? get cart => _cart;

  List<ModuleSettings?>? get modules => cart == null ? [] : cart!.moduleSetting;

  ShoppingCart? get shoppingCart => cart == null ? null : cart!.shoppingCart;

  List<CartItem>? get cartItems => shoppingCart == null ? [] : shoppingCart!.items;

  List<OrderTotalSummary>? get orderSummary => shoppingCart == null ? null : shoppingCart!.orderTotalSummary;

  int? get totalItems => shoppingCart == null ? 0 : shoppingCart!.totalItems;

  DisplayMessage? get inlineMessage {
    if (_cart == null) {
      return null;
    }
    if (_cart?.displayMessage == null) {
      return null;
    }
    return _cart?.displayMessage?.messageDisplayType == MessageDisplayType.Inline ? _cart?.displayMessage : null;
  }

  DisplayMessage? _couponInlineMessage;

  DisplayMessage? get couponInlineMessage => _couponInlineMessage;

  set couponInlineMessage(DisplayMessage? value) {
    _couponInlineMessage = value;
    notifyListeners();
  }

  init() async {
    _cart = await _cartService.getCart();
    notifyListeners();

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
    setBusy(true);

    locator<AnalyticsService>().logAddToCart(itemId: product.productId.toString(), itemName: product.productName ?? '', price: product.unitPrice, value: qty * product.unitPrice!, quantity: qty, currency: 'USD', itemCategory: '');

    if (_cart?.displayMessage != null) displayMessage(_cart?.displayMessage);
  }

  removeItem(CartItem product) async {
    if (isBusy) return;

    setBusy(true);

    _cart = await _cartService.removeItemFromCart(product.productId);

    //TODO Analytics
    // locator<AnalyticsService>().removeFromCart(
    //   itemId: product.productId.toString(),
    //   itemName: product.productName ?? '',
    //   itemCategory: '',
    //   quantity: product.quantity ?? 0,
    //   value: product.unitPrice! * product.quantity!,
    //   price: product.unitPrice,
    //   currency: 'USD',
    // );

    setBusy(false);

    if (_cart?.displayMessage != null) displayMessage(_cart?.displayMessage);
  }

  applyCoupon(BuildContext context) async {
    setBusy(true);

    PageSettings? settings = await _cartService.applyCoupon(promoCodeController.text);

    if (settings?.isSuccess == false) {
      _couponInlineMessage = settings?.displayMessage;
      notifyListeners();
    } else {
      _cart = settings;
      displayMessage(_cart?.displayMessage);

      Navigator.pop(context);
    }

    setBusy(false);

    return;
  }

  displayMessage(DisplayMessage? displayMessage) async {
    if (displayMessage == null) return;

    String? displayType = displayMessage.messageDisplayType;

    if (displayType == MessageDisplayType.SnackBar) {
      toastService.showWidget(
          child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 60, left: 10, right: 10),
        decoration: BoxDecoration(color: AppColor.white, boxShadow: AppStyle.cardShadow, borderRadius: BorderRadius.circular(5)),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (displayMessage.title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(displayMessage.title ?? '', style: AppTextStyle.titleSmall.copyWith(fontSize: 16, color: displayMessage.color), textAlign: TextAlign.start),
                  ),
                if (displayMessage.subText != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(displayMessage.subText ?? '', style: AppTextStyle.titleSmall.copyWith(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start),
                  ),
                VerticalSpacing.d5px(),
                Container(
                  decoration: BoxDecoration(color: AppColor.secondaryBackground, border: Border(left: BorderSide(color: displayMessage.color, width: 2))),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayMessage.message ?? '',
                          textScaleFactor: 1,
                          style: AppTextStyle.bodyMedium,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            displayMessage.icon,
                            color: displayMessage.color,
                            size: 35,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
      return;
    }

    if (displayType == MessageDisplayType.BottomSheet) {
      await dialogService.showBottomSheet(title: displayMessage.title == null ? '' : displayMessage.title, child: DisplayMessageBottomSheet(displayMessage));
      return;
    }

    if (displayType == MessageDisplayType.AlertBox) {
      await dialogService.displayMessage(title: displayMessage.title == null ? '' : displayMessage.title, child: DisplayMessageBottomSheet(displayMessage));
      return;
    }
  }

  onCheckoutClick() async {
    // Todo - Authentication Request
    locator<NavigationService>().pushNamed(Routes.checkout);

    // if (!locator<AuthenticationService>().isAuthenticated) {
    //   bool authenticated = await signInRequest(Images.iconCartBottom,
    //       title: "Checkout",
    //       content:
    //           "Login or Create a free APMEX.com account for fast checkout and easy access to order history.",
    //       showGuestLogin: true);
    //   if (!authenticated) return;
    // }
    //
    // navigationService!
    //     .pushNamed(
    //       Routes.checkout,
    //     )!
    //     .then((value) => init());
  }

  refresh() async {
    _cart = await _cartService.getCart(refresh: true);

    locator<AnalyticsService>().logEvent('view_cart', {
      'currency': 'USD',
      'value': shoppingCart?.orderTotal,
      'items': shoppingCart?.items?.map((e) => {'item_id': e.productId, 'price': e.unitPrice, 'quantity': e.quantity}).toList().toString()
    });

    if (_cart?.displayMessage != null) displayMessage(_cart?.displayMessage);

    notifyListeners();
  }
}
