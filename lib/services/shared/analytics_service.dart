import 'dart:async';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/shopping_cart.dart';
import 'package:bullion/core/models/module/order.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/locator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:kochava_tracker/kochava_tracker.dart';
import '../authentication_service.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  Future<void> setUserId(int? userId) async {
    analytics.setUserId(id: userId.toString());
    FirebaseCrashlytics.instance.setUserIdentifier(userId.toString());
  }

  Future<void> loglogin() async {
    analytics.logLogin();
    KochavaTracker.instance.sendEventWithString("Sign In", locator<AuthenticationService>().getUser?.userId.toString() ?? '');
  }

  Future<void> logSignUp() async {
    analytics.logSignUp(signUpMethod: "Mobile App");
    var koEvent = KochavaTracker.instance.buildEventWithEventType(KochavaTrackerEventType.RegistrationComplete);
    koEvent.setUserId(locator<AuthenticationService>().getUser!.userId.toString());
    koEvent.send();
  }

  Future<void> logFirstPurchase(Order order) async {
    //
    // var eventMapObject = {
    //   "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
    //   "name":  order.orderLineItems?.map((e) => e.productName).toList(),
    //   "content_id": order.orderLineItems?.map((e) => e.productId).toList(),
    //   "price": "\$${order.orderTotal}",
    //   "currency": "USD",
    //   "checkout_as_guest": locator<AuthenticationService>().isGuestUser,
    //   "order_id": order.orderId,
    // };
    //
    // KochavaTracker.instance.sendEventWithDictionary("First Purchase", eventMapObject);

    var gaObject = {
      'currency': 'USD',
      'amount': "\$${order.orderTotal}",
      'product': order.orderLineItems?.map((e) => e.productName).toList().toString(),
      'transaction_id': order.orderId,
      "content_id":  order.orderLineItems?.map((e) => e.productId).toList().toString()
    };
    return locator<AnalyticsService>().logEvent('first_purchase', gaObject);
  }

  Future<void> logPurchase(Order order) async {

    Map<String, dynamic> params = new Map();
    params['currency'] = 'USD';
    params['transaction_id'] = order.orderId;
    params['tax'] = order.tax;
    params['items'] = order.orderLineItems!.map((CartItem e) {
      return {
      "item_id": e.productId.toString(),
      "item_name": e.productName,
      "price": e.unitPrice,
      "value": e.quantity! * e.unitPrice!,
      "quantity": e.quantity,
      "currency": 'USD'
      };
      }).toList().toString();
    params['shipping'] = order.shippingAmount ;
    params['value'] = order.orderTotal;
    params['coupon'] = order.coupon;

    logEvent("purchase", params);

    // var eventMapObject = {
    //   "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
    //   "name": order.orderLineItems?.fold<List<String?>>([], (prev, element) => List.from(prev)..add(element.productName)),
    //   "content_id": order.orderLineItems?.fold<List<int?>>([], (prev, element) => List.from(prev)..add(element.productId)),
    //   "price": order.orderTotal,
    //   "currency": "USD",
    //   "checkout_as_guest": locator<AuthenticationService>().isGuestUser,
    //   "order_id": order.orderId,
    //   "action": order.customerType,
    // };

    // KochavaTracker.instance.sendEventWithDictionary("Purchase", eventMapObject);

    // if (Platform.isIOS) {
    //   Riskified.logSensitiveDeviceInfo();
    // }
  }

  Future<void> logShare({required String itemId, required String contentType, String method = "mobile"}) async {
    analytics.logShare(itemId: itemId, contentType: contentType, method: method);
    debugPrint('Analytics: Share - ${contentType.toString()}');
  }

  //Log Screen Name is deprecated user logscreen view
  Future<void> logScreenName(String screenName) async {
    //TODO - RISKIFIED
    // Riskified.logRequest("${locator<AppConfigService>().config!.baseApiUrl}${screenName}");
    await analytics.setCurrentScreen(screenName: screenName);
  }

  Future<void> logScreenView(String? screenName, {String? className = ""}) async {
    if (className == "") {
      if (screenName!.contains("product")) {
        className = "product";
      } else if (screenName.contains("category")) {
        className = "category";
      } else if (screenName.contains("search")) {
        className = "search";
      } else if (screenName.contains("account")) {
        className = "account";
      } else {
        className = screenName;
      }
    }
    logEvent('screen_view', {'screen_name': screenName, 'screen_class': className});
    //TODO - RISKIFIED
    // unawaited(Riskified.logRequest("${locator<AppConfigService>().config!.baseApiUrl}$screenName"));
  }

  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await analytics.logEvent(name: name, parameters: filterOutNulls(parameters));
    debugPrint('Analytics: $name - ${parameters.toString()}');
  }

  Future<void> logAddToCart({required String itemId, required String itemName, required String itemCategory, required int quantity, double? price, double? value, String? currency}) async {
    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name": itemName,
      "content_id": itemId,
      "item_quantity": quantity,
      "referral_form": "",
    };

    await analytics.logAddToCart(items: [AnalyticsEventItem(itemId: itemId, itemName: itemName, itemCategory: itemCategory, quantity: quantity, price: price)], value: value, currency: currency);
    KochavaTracker.instance.sendEventWithDictionary("Add to Cart", eventMapObject);
    debugPrint('Analytics: Add To Cart');
  }

  void logAppOpen() {
    analytics.logAppOpen();
  }

  //TODO log Search need to be implemented
  Future<void> logSearch(String searchTerm) async {
    await analytics.logSearch(searchTerm: searchTerm);
    KochavaTracker.instance.sendEventWithString("Search", searchTerm);
    debugPrint('Analytics: log search $searchTerm');
  }

  Future<void> logBeginCheckout(ShoppingCart? shoppingCart) async {
    // var eventMapObject = {
    //   "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
    //   "name":  _shoppingCart!.items?.fold<List<String?>>([], (prev, element) => List.from(prev)..add(element.productName)),
    //   "content_id": _shoppingCart.items?.fold<List<int?>>([], (prev, element) => List.from(prev)..add(element.productId)),
    //   "checkout_as_guest":  locator<AuthenticationService>().isGuestUser,
    //   "currency": "USD",
    // };
    //
    // KochavaTracker.instance.sendEventWithDictionary("Checkout Start", eventMapObject);
    await analytics.logBeginCheckout(value: shoppingCart?.orderTotal , currency: shoppingCart?.currency ?? 'USD',
        items: shoppingCart?.items?.map((e) => AnalyticsEventItem(
            itemId: e.productId.toString(),
            itemName: e.productName,
            quantity: e.quantity,
            price: e.unitPrice,
            currency: 'USD'
        )).toList() ?? [],
    );
  }

  Future<void> logProductView(ProductDetails? productDetails) async {
    locator<AnalyticsService>().logEvent('view_item', {
      'currency': productDetails?.overview!.pricing!.currency ?? 'USD',
      'items': [
        {
          "item_id": productDetails?.productId,
          "item_name": productDetails?.overview!.name
        }
      ].toString(),
      "item": productDetails?.productId,
      'value': productDetails?.overview?.pricing?.newPrice?.toString()
    });

    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name":  productDetails?.overview?.name,
      "content_id": productDetails?.productId,
    };

    KochavaTracker.instance.sendEventWithDictionary("View Product", eventMapObject);
  }

  Future<void> removeFromCart(
      {required String itemId,
        required String itemName,
        required String itemCategory,
        required int quantity,
        double? price,
        double? value,
        String? currency}) async {
    locator<AnalyticsService>().logEvent('remove_from_cart', {
      'currency': 'USD',
      'item_id': itemId,
      'item_name': itemName,
      'value': price
    });
    debugPrint('Analytics: Remove Cart');
  }

  logAddToWishlist(ProductDetails productDetails) {
    analytics.logAddToWishlist(
        currency: "USD",
        value: productDetails.overview!.pricing!.newPrice,
        items: [
          productDetails.overview!.analyticEventItemObject()
        ]
    );
  }


  Map<String, Object> filterOutNulls(Map<String, Object?> parameters) {
    final Map<String, Object> filtered = <String, Object>{};
    parameters.forEach((String key, Object? value) {
      if (value != null) {
        filtered[key] = value;
      }
    });
    return filtered;
  }
}
