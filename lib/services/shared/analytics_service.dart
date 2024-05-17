import 'dart:async';
import 'dart:io';
import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/shopping_cart.dart';
import 'package:bullion/core/models/module/order.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riskified/flutter_riskified.dart';
import 'package:kochava_tracker/kochava_tracker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../authentication_service.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  Future<void> setUserId(int? userId) async {
    analytics.setUserId(id: userId.toString());
    FirebaseCrashlytics.instance.setUserIdentifier(userId.toString());
  }

  Future<void> logLogin() async {
    analytics.logLogin();
    analytics.logEvent(name: "accounts", parameters: {"eventActParam": "login", "eventLblParam": "success"});
    KochavaTracker.instance.sendEventWithString("Sign In",
        locator<AuthenticationService>().getUser?.userId.toString() ?? '');
  }

  Future<void> logSignUp() async {
    analytics.logSignUp(signUpMethod: "Mobile App");
    analytics.logEvent(name: "accounts", parameters: {
      "eventActParam": "registration",
      "eventLblParam": "success"
    });
    var koEvent = KochavaTracker.instance.buildEventWithEventType(KochavaTrackerEventType.RegistrationComplete);
    koEvent.setUserId(locator<AuthenticationService>().getUser!.userId.toString());
    koEvent.send();
  }

  Future<void> logFirstPurchase(Order order) async {

    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name":  order.orderLineItems?.map((e) => e.productName).toList(),
      "content_id": order.orderLineItems?.map((e) => e.productId).toList(),
      "price": "\$${order.orderTotal}",
      "currency": "USD",
      "checkout_as_guest": locator<AuthenticationService>().isGuestUser,
      "order_id": order.orderId,
    };

    KochavaTracker.instance.sendEventWithDictionary("First Purchase", eventMapObject);

    Map<String, dynamic> gaObject = {};
    gaObject['currency'] = 'USD';
    gaObject['amount'] = "\$${order.orderTotal}";
    gaObject['product'] = order.orderLineItems?.map((e) => e.productName).toList().toString();
    gaObject['transaction_id'] = order.orderId;
    gaObject['content_id'] = order.orderLineItems?.map((e) => e.productId).toList().toString();
    gaObject['tax'] = order.tax;
    gaObject['shipping'] = order.shippingAmount;
    gaObject['value'] = order.orderTotal;
    gaObject['coupon'] = order.coupon;
    gaObject['affiliation'] = "APMEX_MOBILE";
    gaObject['predictedMargin'] = order.predictiveMargin;
    gaObject['u_id'] = locator<AuthenticationService>().getUser?.userId.toString();
    gaObject['club_status'] = getClubStatus(locator<AuthenticationService>().getUser?.clubStatus);
    gaObject['register_status'] = locator<AuthenticationService>().isGuestUser ? 0 : 1;
    gaObject['authentication_status'] = 1;
    gaObject['express_checkout'] = 1;
    gaObject['purchaser'] = order.customerType == "returning" ? 1 : 0;
    gaObject['life_cycle_segment'] = order.lifeCycleSegment;
    gaObject['customer_score'] = order.customerScore;
    return locator<AnalyticsService>().logEvent('first_purchase', gaObject);
  }

  Future<void> logPurchase(Order order) async {

    Map<String, dynamic> params = {};
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
    params['affiliation'] = "APMEX_MOBILE";
    params['predictedMargin'] = order.predictiveMargin;
    params['u_id'] = locator<AuthenticationService>().getUser?.userId.toString();
    params['club_status'] = getClubStatus(locator<AuthenticationService>().getUser?.clubStatus);
    params['register_status'] =  locator<AuthenticationService>().isGuestUser ? 0 : 1;
    params['authentication_status'] = 1;
    params['express_checkout'] = 1;
    params['purchaser'] = order.customerType == "returning" ? 1 : 0;
    params['life_cycle_segment'] = order.lifeCycleSegment;
    params['customer_score'] = order.customerScore;

    logEvent("purchase", params);

    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name": order.orderLineItems?.fold<List<String?>>([], (prev, element) => List.from(prev)..add(element.productName)),
      "content_id": order.orderLineItems?.fold<List<int?>>([], (prev, element) => List.from(prev)..add(element.productId)),
      "price": order.orderTotal,
      "currency": "USD",
      "checkout_as_guest": locator<AuthenticationService>().isGuestUser,
      "order_id": order.orderId,
      "action": order.customerType,
    };

    KochavaTracker.instance.sendEventWithDictionary("Purchase", eventMapObject);

    if (Platform.isIOS) {
      Riskified.logSensitiveDeviceInfo();
    }
  }

  Future<void> logShare({required String itemId, required String contentType, String method = "mobile"}) async {
    analytics.logShare(itemId: itemId, contentType: contentType, method: method);
    debugPrint('Analytics: Share - ${contentType.toString()}');
  }

  //Log Screen Name is deprecated use logScreenView
  Future<void> logScreenName(String screenName) async {
    Riskified.logRequest("${locator<AppConfigService>().config?.baseApiUrl}$screenName");
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
    unawaited(Riskified.logRequest("${locator<AppConfigService>().config?.baseApiUrl}$screenName"));
  }

  Future<void> logFilter(String? displayName) async{
    await logEvent('filter_by', {'filter_item': displayName});
  }

  Future<void> logSortBy(String? name) async{
    await logEvent('sort_by', {'sort_item': name});
  }

  Future<void>logAppNavigation({String? label}) async {
    await logEvent('app_navigation', {"button_text": label});
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
    // await analytics.logSearch(searchTerm: searchTerm);
    logEvent("search", {"search_term": searchTerm});

    KochavaTracker.instance.sendEventWithString("Search", searchTerm);
    debugPrint('Analytics: log search $searchTerm');
  }

  Future<void> logSearchSuccess(String searchTerm) async {
    analytics.logViewSearchResults(searchTerm: searchTerm);
    debugPrint('Analytics: log search success ${searchTerm}');
  }

  Future<void> logSearchFailed(String searchTerm) async {
    logEvent("internal_search",
        {"eventActParam": "failed search", "eventLblParam": searchTerm});
    debugPrint('Analytics: log search failed ${searchTerm}');
  }

  Future<void> logBeginCheckout(ShoppingCart? shoppingCart) async {
    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name":  shoppingCart!.items?.fold<List<String?>>([], (prev, element) => List.from(prev)..add(element.productName)),
      "content_id": shoppingCart.items?.fold<List<int?>>([], (prev, element) => List.from(prev)..add(element.productId)),
      "checkout_as_guest":  locator<AuthenticationService>().isGuestUser,
      "currency": "USD",
    };

    KochavaTracker.instance.sendEventWithDictionary("Checkout Start", eventMapObject);
    await analytics.logBeginCheckout(value: shoppingCart.orderTotal , currency: shoppingCart.currency ?? 'USD',
        coupon: '',
        items: shoppingCart.items?.map((e) => AnalyticsEventItem(
            itemId: e.productId.toString(),
            itemName: e.productName,
            quantity: e.quantity,
            price: e.unitPrice,
            currency: 'USD'
        )).toList() ?? [],
    );
  }

  Future<void> logProductView(ProductDetails? productDetails) async {
    // locator<AnalyticsService>().logEvent('view_item', {
    //   'currency': productDetails?.overview!.pricing!.currency ?? 'USD',
    //   'items': [
    //     {
    //       "item_id": productDetails?.productId,
    //       "item_name": productDetails?.overview!.name
    //     }
    //   ].toString(),
    //   "item": productDetails?.productId,
    //   'value': productDetails?.overview?.pricing?.newPrice?.toString()
    // });

    analytics.logViewItem(
        items: [productDetails!.overview!.analyticEventItemObject()],
        currency: productDetails.overview!.pricing!.currency ?? 'USD',
        value: productDetails.overview?.pricing?.newPrice);

    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name":  productDetails?.overview?.name,
      "content_id": productDetails?.productId,
    };

    KochavaTracker.instance.sendEventWithDictionary("View Product", eventMapObject);
  }

  Future<void> logModuleClick(String? moduleName, String? clickText) async
  {
    if(moduleName!=null && clickText != null)
    {
      await logEvent('module_click', {"module_name": moduleName, "click_text": clickText});
    }
  }

  Future<void> logSelectItem(ProductOverview _product,
      {String? dyDecisionId,
        String? listId,
        String? listName,
        int? index}) async {
    // KOCHAVA EVENT ------
    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name": _product.name,
      "content_id": _product.productId,
    };

    KochavaTracker.instance
        .sendEventWithDictionary("Select Product", eventMapObject);
    // END KOCHAVA EVENT ------

    analytics.logSelectItem(
        itemListId: listId,
        itemListName: listName,
        items: [_product.analyticEventItemObject(index: index)]);
    debugPrint(
        "Analytics: Log Select Item: $listId $listName ${_product.name}");

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

    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name": itemName,
      "content_id": itemId,
      "item_quantity": quantity,
      "referral_form": "",
    };

    KochavaTracker.instance
        .sendEventWithDictionary("Remove Cart", eventMapObject);

    debugPrint('Analytics: Remove Cart');
  }

  logViewItemList(
      String? listId, String? listName, List<ProductOverview>? items) {
    analytics.logViewItemList(
        itemListId: listId,
        itemListName: listName,
        items: items
            ?.asMap()
            .map((index, e) =>
              MapEntry(index, e.analyticEventItemObject(index: index)))
            .values
            .toList());
    debugPrint("LogViewItemList $listName $listId: Success");
    return;
  }


  logAddToWishlist(ProductDetails productDetails) {

    analytics.logAddToWishlist(
        currency: "USD",
        value: productDetails.overview!.pricing!.newPrice,
        items: [
          productDetails.overview!.analyticEventItemObject()
        ]
    );

    var eventMapObject = {
      "user_id": locator<AuthenticationService>().getUser?.userId.toString(),
      "name": productDetails.overview?.name,
      "content_id": productDetails.productId,
    };

    KochavaTracker.instance
        .sendEventWithDictionary("Add Wish List", eventMapObject);
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

  logViewCartItem(
      {String? currency, double? orderTotal, List<CartItem>? cartItem}) {
    analytics.logViewCart(currency: currency, value: orderTotal, items: [
      ...cartItem
          ?.map((e) => AnalyticsEventItem(
        itemId: e.productId.toString(),
        itemName: e.productName,
        price: e.unitPrice,
        quantity: e.quantity,
      ))
          .toList() ??
          []
    ]);
  }

  logAddPaymentInfo({String? currency, double? orderTotal, String? coupon, String? paymentType, List<CartItem>? cartItem}) {
    analytics.logAddPaymentInfo(
        currency: currency,
        value: orderTotal,
        coupon: coupon,
        paymentType: paymentType,
        items: [
          ...cartItem?.map((e) => AnalyticsEventItem(
            itemId: e.productId.toString(),
            itemName: e.productName,
            price: e.unitPrice,
            quantity: e.quantity,
          )).toList() ?? []
        ]
    );

    debugPrint("Analytics Service: Log Add Payment");
  }


  logShippingAddressInfo({String? currency, double? orderTotal, String? coupon, String? shippingTier, List<CartItem>? cartItem}) {
    analytics.logAddShippingInfo(
        currency: currency,
        value: orderTotal,
        coupon: coupon,
        shippingTier: shippingTier,
        items: [
          ...cartItem?.map((e) => AnalyticsEventItem(
            itemId: e.productId.toString(),
            itemName: e.productName,
            price: e.unitPrice,
            quantity: e.quantity,
          )).toList() ?? []
        ]
    );

    debugPrint("Analytics Service: Log Shipping Address");
  }

  logProductDetailViewInteraction(ProductOverview? productOverview) {
    locator<AnalyticsService>().logEvent(
      "product_details",
      {
        "item_name": productOverview?.name,
        "item_id": productOverview?.productId
      },
    );
  }

  logProductSpecViewInteraction(ProductOverview? productOverview) {
    locator<AnalyticsService>().logEvent(
      "product_specs",
      {
        "item_name": productOverview?.name,
        "item_id": productOverview?.productId
      },
    );
  }

  logProductReviewViewInteraction(ProductOverview? productOverview) {
    locator<AnalyticsService>().logEvent(
      "product_review",
      {
        "item_name": productOverview?.name,
        "item_id": productOverview?.productId
      },
    );
  }

  logPriceAlertInteraction(ProductOverview? productOverview) {
    locator<AnalyticsService>().logEvent(
      "price_alert",
      {
        "item_name": productOverview?.name,
        "item_id": productOverview?.productId
      },
    );
  }

  logShareItemInteraction(ProductOverview? productOverview) {
    locator<AnalyticsService>().logEvent(
      "share_item",
      {
        "item_name": productOverview?.name,
        "item_id": productOverview?.productId
      },
    );
  }
}
