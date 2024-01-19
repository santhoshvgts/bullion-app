//
//
// import 'package:flutter/material.dart';
// import 'package:bullion/core/constants/display_type.dart';
// import 'package:bullion/core/enums/viewstate.dart';
// import 'package:bullion/core/models/module/cart/cart_item.dart';
// import 'package:bullion/core/models/module/cart/display_message.dart';
// import 'package:bullion/core/models/module/cart/order_total_summary.dart';
// import 'package:bullion/core/models/module/cart/shopping_cart.dart';
// import 'package:bullion/core/models/module/checkout/checkout_address.dart';
// import 'package:bullion/core/models/module/checkout/payment_method.dart';
// import 'package:bullion/core/models/module/module_settings.dart';
// import 'package:bullion/core/models/module/page_settings.dart';
// import 'package:bullion/core/models/user_address.dart';
// import 'package:bullion/core/res/colors.dart';
// import 'package:bullion/core/res/styles.dart';
// import 'package:bullion/locator.dart';
// import 'package:bullion/services/api/checkout_api.dart';
// import 'package:bullion/services/cart_service.dart';
// import 'package:bullion/services/shared/dialog_service.dart';
// import 'package:bullion/ui/v2/views/product/cart/display_message_toast.dart';
// import 'package:bullion/ui/views/my_base_view_model.dart';
//
// class ReviewOrderViewModel extends MyBaseViewModel {
//
//   final CheckoutApi? _checkoutApi = locator<CheckoutApi>();
//
//   bool _isLoading = false;
//
//   bool? isPriceExpired = false;
//
//   bool get isLoading => _isLoading;
//
//   set isLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   ReviewOrderViewModel(this.isPriceExpired);
//
//   PageSettings? _cart;
//
//   PageSettings? get cart => _cart;
//
//   List<ModuleSettings?>? get modules => cart == null ? [] : cart!.moduleSetting;
//
//   ShoppingCart? get shoppingCart => cart == null ? null : cart!.shoppingCart;
//
//   List<CartItem>? get cartItems => shoppingCart == null ? [] : shoppingCart!.items;
//
//   List<CartItem> get taxCartItems => cartItems!.where((element) => element.isTaxable!).toList();
//
//   List<CartItem> get nonTaxCartItems => cartItems!.where((element) => !element.isTaxable!).toList();
//
//   List<OrderTotalSummary>? get orderSummary => shoppingCart == null ? null : shoppingCart!.orderTotalSummary;
//
//   int? get totalItems => shoppingCart == null ? 0 : shoppingCart!.totalItems;
//
//   DisplayMessage? get inlineMessage {
//     if (_cart == null)
//       return null;
//
//     if (_cart!.displayMessage == null){
//       return null;
//     }
//     return _cart!.displayMessage!.messageDisplayType == MessageDisplayType.Inline ? _cart!.displayMessage : null;
//   }
//
//   DisplayMessage? _couponInlineMessage;
//
//   DisplayMessage? get couponInlineMessage => _couponInlineMessage;
//
//   set couponInlineMessage(DisplayMessage? value) {
//     _couponInlineMessage = value;
//     notifyListeners();
//   }
//
//   init() async {
//     setState(ViewState.Busy);
//     // locator<CartService>().getCart(refresh: true);
//
//     _cart =  isPriceExpired! ? await _checkoutApi!.getExpiredCart() : await _checkoutApi!.getCheckoutCart();
//
//     if(_cart!.displayMessage != null)
//       _displayMessage();
//
//     setState(ViewState.Idle);
//   }
//
//   _displayMessage() async {
//
//     if (_cart!.displayMessage == null) return;
//
//     String? displayType = _cart!.displayMessage!.messageDisplayType;
//
//     if (displayType == MessageDisplayType.SnackBar) {
//       toastService!.showWidget(child: Container(
//         padding: const EdgeInsets.all(10.0),
//         width: double.infinity,
//         margin: EdgeInsets.only(bottom: 60, left: 10 ,right: 10),
//         decoration: BoxDecoration(
//             color: AppColor.white,
//             boxShadow: AppStyle.cardShadow,
//             borderRadius: BorderRadius.circular(5)
//         ),
//         child: Wrap(
//           children: [
//             Row(
//               children: [
//
//                 Container(
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.only(right: 10),
//                     child: Icon(_cart!.displayMessage!.icon, color: _cart!.displayMessage!.color, size: 35,)
//                 ),
//
//                 Expanded(
//                   child: Column(
//                     children: [
//
//                       if (_cart!.displayMessage!.title != null)
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5),
//                           child: Text(_cart!.displayMessage!.title!, style: AppTextStyle.title.copyWith(fontSize: 14, color: _cart!.displayMessage!.color), textAlign: TextAlign.start),
//                         ),
//
//                       Text(_cart!.displayMessage!.message!, style: AppTextStyle.body, textAlign: TextAlign.start),
//
//                     ],
//                   ),
//                 ),
//
//               ],
//             ),
//           ],
//         ),
//       ));
//       return;
//     }
//
//     if (displayType == MessageDisplayType.BottomSheet) {
//       await locator<DialogService>().showBottomSheet(title: _cart!.displayMessage!.title, child: DisplayMessageBottomSheet(_cart!.displayMessage));
//       return;
//     }
//
//     if (displayType == MessageDisplayType.AlertBox) {
//       await locator<DialogService>().displayMessage(title: _cart!.displayMessage!.title, child: DisplayMessageBottomSheet(_cart!.displayMessage));
//       return;
//     }
//
//   }
//
// }