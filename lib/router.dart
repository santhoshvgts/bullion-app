import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/ui/view/core/page/main_page.dart';
import 'package:bullion/ui/view/core/page_middleware.dart';
import 'package:bullion/ui/view/main/forgot_password/forgot_password_page.dart';
import 'package:bullion/ui/view/main/intro/intro_page.dart';
import 'package:bullion/ui/view/main/login/login_page.dart';
import 'package:bullion/ui/view/main/register/register_page.dart';
import 'package:bullion/ui/view/main/splash/splash_page.dart';
import 'package:bullion/ui/view/product/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'ui/view/dashboard/dashboard_page.dart';
const String initialRoute = "login";

class Routes {


  static const authenticatedRoutePrefix = [ "/account/", "/checkout/" ];

  static const String dashboard = "/pages/home";
  static const String home = "/pages/home";
  static const String shop = "/pages/shop";
  static const String deals = "/pages/deals";
  static const String settings = "/settings";

  static const String spotPrice = "/spotprices";

  // Cart & Checkout
  static const String viewCart = "/cart/viewcart";
  static const String reviewCart = "/checkout/review";
  static const String expiredCart = "/cart/expiredcart";
  static const String checkout = "/checkout";
  static const String orderPlaced = "/orders/success";
  static const String checkoutAddress = "/checkout/address";
  static const String checkoutPayments = "/checkout/payments";

  static const String splash = "/";
  static const String login = "/account/login";
  static const String register = "/account/register";
  static const String registerGuest = "/account/register/guest";
  static const String forgotPassword = "/account/forgotpassword";
  static const String resetPassword = "/account/resetpassword";
  static const String forgotPasswordSuccess = "/forgot_password_success";

  static const String loading = "/loading";
  static const String search = "/search";
  static const String main = "/main";

  static String productDesc(id) => "/product/details/${id}";
  static String productSpec(id) => "/product/specs/${id}";
  static String productReview(id) => "/product/reviews/${id}";
  static String productWriteReview(id) => "/product/reviews/add/${id}";

  static const String addAddress = "/addAddress";

  static const String introPage = "/main/intro";
  static const String marketAlertEntry = "/market_alert/entry";
  static const String marketNews = "/market_news";


  static const String accountSetting = "/accountSetting";
  static const String orderSuccess = "/orderSuccess";
  static const String portfolioAsset = "/portfolioAsset";
  static const String portfolioAddAsset = "/portfolioAddAsset";
  static const String portfolioEditAsset = "/portfolioEditAsset";

  //Accounts
  static const String myProfile = "/account/myprofile";
  static const String changeEmail = "/account/changeemail";
  static const String changePassword = "/account/changepassword";
  static const String myAddressBook = "/account/addressbook";
  static const String myPortfolio = "/account/portfolio";
  static const String myOrders = "/account/orders";
  static const String myRewards = "/account/myrewards";
  static const String myRewardTransactions = "/account/myrewards/transaction";
  static const String myOrderDetails = "/account/orderdetails";
  static const String myFavorites = "/account/myfavorites";
  static const String myProductAlert = "/account/productalerts";
  static const String myProductPriceAlert = "/account/myproductpricealerts";
  static const String myClubStatus = "/account/myclubstatus";
  static const String myClub = "/account/myclub";
  static const String myMarketAlerts = "/account/marketalerts";

  static const String customizeHomePage = "/account/customizeHomePage";

  static const String searchHistory = "/search/history";
  static const String recentlyViewed = "recentlyviewed";
  static const String recentlyBought = "recentlybought";
  static const String recentSearches = "recentsearches";

  static const String myProductReviews = "/account/productreviews";
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("Route ${settings.name}");
    locator<AnalyticsService>().logScreenView(settings.name);

    switch (settings.name) {
      case Routes.splash:
        return NoTransitionRoute(
          builder: (_) => SplashPage(),
          settings: RouteSettings(name: settings.name),
        );

      case Routes.introPage:
        return NoTransitionRoute(
          builder: (_) => IntroPage(),
          settings: RouteSettings(name: settings.name),
        );

      case Routes.dashboard:
        return MaterialPageRoute(
          builder: (_) => DashboardPage(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );

      // case Routes.settings:
      //   return MaterialPageRoute(
      //     builder: (_) =>  SettingsPage(key: PageStorageKey('Settings'),),
      //     settings: RouteSettings(
      //       name: settings.name,
      //     ),
      //   );

      // case Routes.creditCard:
      //   return MaterialPageRoute(
      //       builder: (_) => CreditCardPage(),
      //       settings: RouteSettings(name: settings.name));


    // Cart
      //
    //   case Routes.viewCart:
    //     return MaterialPageRoute(
    //         builder: (_) => CartPage(redirectDisplayMessage: settings.arguments as DisplayMessage?,),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.reviewCart:
    //     return MaterialPageRoute(
    //         builder: (_) => ReviewOrderPage(
    //           fromPriceExpiry: false,
    //         ),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.expiredCart:
    //     return MaterialPageRoute(
    //         builder: (_) => ReviewOrderPage(
    //           fromPriceExpiry: true,
    //         ),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.checkout:
    //     return MaterialPageRoute(
    //         builder: (_) => CheckoutPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.checkoutAddress:
    //     return MaterialPageRoute(
    //         builder: (_) => DeliveryAddressPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.checkoutPayments:
    //     return MaterialPageRoute(
    //         builder: (_) => PaymentMethodPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //
    //   case Routes.marketAlertEntry:
    //     return MaterialPageRoute(
    //       builder: (_) => MarketAlertEntryPage(
    //         settings.arguments as String?,
    //       ),
    //       settings: RouteSettings(
    //         name: settings.name,
    //       ),
    //     );
    //
    //   case 'category':
    //   case Routes.main:
    //     return MaterialPageRoute(builder: (context) => MainPage(path: settings.name));
    //
    //   case Routes.search:
    //     return MaterialPageRoute(
    //       builder: (_) => SearchPage(),
    //       settings: RouteSettings(
    //         name: settings.name,
    //       ),
    //     );
    //
    //   case Routes.myFavorites:
    //     return MaterialPageRoute(
    //         builder: (_) => FavoritePage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.myProductAlert:
    //     return MaterialPageRoute(
    //         builder: (_) => ProductAlertPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.myProductPriceAlert:
    //     return MaterialPageRoute(
    //         builder: (_) => PriceAlertPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.orderSuccess:
    //     return MaterialPageRoute(
    //         builder: (_) => OrderSuccessPage(settings.arguments as Order?),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.addAddress:
    //     var data = settings.arguments as int?;
    //     return MaterialPageRoute(
    //         builder: (_) => AddAddressBottomSheet(data),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.accountSetting:
    //     return MaterialPageRoute(
    //         builder: (_) => AccountSettingsPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.myRewardTransactions:
    //     return MaterialPageRoute(
    //         builder: (_) => RewardTransactionHistory(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   //  -----------  PORTFOLIO -----------
    //   case Routes.portfolioAsset:
    //     return MaterialPageRoute(
    //       builder: (_) => PortfolioAssetPage(settings.arguments as String?),
    //       settings: RouteSettings(
    //         name: settings.name,
    //       ),
    //     );
    //
    //   case Routes.portfolioAddAsset:
    //     return MaterialPageRoute(
    //       builder: (_) => AssetEntryPage(),
    //       settings: RouteSettings(
    //         name: settings.name,
    //       ),
    //     );
    //
    //   case Routes.portfolioEditAsset:
    //     return MaterialPageRoute(
    //       builder: (_) => AssetEditPage(settings.arguments as String?),
    //       settings: RouteSettings(
    //         name: settings.name,
    //       ),
    //     );
    //   //  -----------  END PORTFOLIO -----------
    //
    //   // Account
    //   case Routes.myProfile:
    //     return MaterialPageRoute(
    //         builder: (_) => ProfilePage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.changeEmail:
    //     return MaterialPageRoute(
    //         builder: (_) => ChangeEmailPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.changePassword:
    //     return MaterialPageRoute(
    //         builder: (_) => ChangePasswordPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.myAddressBook:
    //     return MaterialPageRoute(
    //         builder: (_) => AddressPage(),
    //         settings: RouteSettings(name: settings.name));
    //
    //   case Routes.myPortfolio:
    //     return MaterialPageRoute(
    //       builder: (_) => PortfolioPage(),
    //       settings: RouteSettings(
    //         name: settings.name,
    //       ),
    //     );
    //
    //   case Routes.recentlyViewed:
    //     return MaterialPageRoute(
    //       builder: (_) => RecentlyViewedPage(),
    //       settings: RouteSettings(name: settings.name),
    //     );
    //
    //   case Routes.searchHistory:
    //     return MaterialPageRoute(
    //       builder: (_) => SearchHistoryPage(),
    //       settings: RouteSettings(name: settings.name),
    //     );
    //
    //   case Routes.recentlyBought:
    //     return MaterialPageRoute(
    //       builder: (_) => RecentlyBoughtPage(),
    //       settings: RouteSettings(name: settings.name),
    //     );
    //
    //   case Routes.myOrders:
    //     return MaterialPageRoute(
    //         builder: (_) => OrderListPage(),
    //         settings: RouteSettings(name: settings.name));
    //   // End Account
    }

    var uri = Uri.parse(settings.name!);
    Logger.d(settings.name);
    Logger.d(uri.pathSegments.toString());
    Logger.d(uri.pathSegments.toString());

    try {
      var campaign = uri.queryParameters['_campaign'];
      if (campaign != null && campaign.isNotEmpty) {
        var promo = campaign.split('-');
        locator<AnalyticsService>().logEvent('select_promotion', {
          'promotion_id': promo.length < 1 ? '' : promo[0] ,
          'promotion_name': promo.length < 2 ? '' : promo[1],
          'creative_name': promo.length < 3 ? '' : promo[2],
          'creative_slot': promo.length < 4 ? '' : promo[3],
          'location_id': promo.length < 5 ? '' : promo[4]
        });
      }
    } catch(ex, st) {
      Logger.e("Campaign Error in Routing", e: ex, s: st);
    }

    if (uri.pathSegments.isEmpty) {
      return TransparentRoute(builder: (context) => PageMiddleware(settings.name, settings.arguments));
    }

    switch (uri.pathSegments.first) {
      case "category":
        return MaterialPageRoute(builder: (context) => MainPage(path: settings.name));

      // case "search":
      //   return MaterialPageRoute(builder: (context) => SearchResultPage(settings.name,));

      case "pages":
        return MaterialPageRoute(builder: (context) => MainPage(path: settings.name,));

      // case "market_news":
      //   return MaterialPageRoute(builder: (context) => MarketNewsPage(metalName: uri.pathSegments.last));

      // case "orders":
      //   if (uri.pathSegments[1] == "success") {
      //     Map<String, dynamic> data = new Map();
      //     data['order_id'] = uri.pathSegments[uri.pathSegments.length - 1];
      //     data['from_success'] = true;
      //     return MaterialPageRoute(builder: (_) => OrderDetailPage(data), settings: RouteSettings(name: settings.name));
      //   }
      //
      //   // locator<PageMiddlewareService>().getRouteAndRedirect(settings.name, settings.arguments);
      //   return TransparentRoute(builder: (context) => PageMiddleware(settings.name, settings.arguments));

      // case "spot-prices":
      // case "spotprices":
      //   String metalName = "gold";
      //   if (uri.pathSegments.length > 1) {
      //     metalName = uri.pathSegments.last.replaceAll('-', ' ').toTitleCase();
      //   }
      //   return MaterialPageRoute(builder: (_) => SpotPricePage(metalName,uri.toString()), settings: RouteSettings(name: settings.name));

      case "product":
      //   if (settings.name!.startsWith("/product/reviews/add/")) {
      //     return MaterialPageRoute(
      //       builder: (_) => SubmitReviewPage(settings.arguments as int?),
      //       settings: RouteSettings(
      //         name: settings.name,
      //       ),
      //     );
      //   } else if (settings.name!.startsWith("/product/reviews/")) {
      //     return MaterialPageRoute(
      //       builder: (_) => ProductReviewPage(settings.arguments as ProductDetails?),
      //       settings: RouteSettings(
      //         name: settings.name,
      //       ),
      //     );
      //   } else if (settings.name!.startsWith("/product/details/")) {
      //     return MaterialPageRoute(
      //       builder: (_) => ProductDescriptionPage(settings.arguments as String?),
      //       settings: RouteSettings(
      //         name: settings.name,
      //       ),
      //     );
      //   } else if (settings.name!.startsWith("/product/specs/")) {
      //     return MaterialPageRoute(
      //       builder: (_) => ProductSpecificationPage(settings.arguments as List<Specifications>?),
      //       settings: RouteSettings(
      //         name: settings.name,
      //       ),
      //     );
      //   }
      //
        return MaterialPageRoute(builder: (context) => ProductPage(productDetails: settings.arguments as ProductDetails?, targetUrl: settings.name,));

      case "account":
        return accountRoute(settings);

      default:
      // locator<PageMiddlewareService>().getRouteAndRedirect(settings.name, settings.arguments);
        return TransparentRoute(builder: (context) => PageMiddleware(settings.name, settings.arguments));
    }
  }

  static PageRoute accountRoute(RouteSettings settings) {
    Uri uri = Uri.parse(settings.name!);
    if (uri.pathSegments.length > 1) {
      switch (uri.pathSegments[1].toLowerCase()) {
      // Order Details
      //   case "orderdetails":
      //     Map<String, dynamic> data = new Map();
      //     data['order_id'] = uri.pathSegments[uri.pathSegments.length - 1];
      //     data['from_success'] = false;
      //     return MaterialPageRoute(builder: (_) => OrderDetailPage(data), settings: RouteSettings(name: settings.name));
      //
      //   case "resetpassword":
      //     return MaterialPageRoute(
      //       builder: (_) =>
      //           ResetPasswordPage(uri.pathSegments[uri.pathSegments.length - 1]),
      //       settings: RouteSettings(name: settings.name),
      //     );
      //
      //   case "productreviews":
      //     return MaterialPageRoute(
      //       builder: (_) => ReviewListPage(),
      //       settings: RouteSettings(name: settings.name),
      //     );
      //
      //   case "myclubstatus":
      //     return MaterialPageRoute(
      //       builder: (_) => ApmexClubPage(),
      //       settings: RouteSettings(name: settings.name),
      //     );
      //
      //   case "myclub":
      //     return MaterialPageRoute(
      //       builder: (_) => ApmexClubPage(),
      //       settings: RouteSettings(name: settings.name),
      //     );
      //
      //   case "myrewards":
      //     return MaterialPageRoute(
      //       builder: (_) => BullionCardPage(),
      //       settings: RouteSettings(name: settings.name),
      //     );
      //
      //   case "marketalerts":
      //     String metalName = "gold";
      //     if (uri.pathSegments.length > 2) {
      //       metalName = uri.pathSegments.last;
      //     }
      //
      //     return MaterialPageRoute(
      //       builder: (_) => MarketAlertPage(metalName),
      //       settings: RouteSettings(
      //         name: settings.name,
      //       ),
      //     );

        case "login":
          Map? data = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (_) => LoginPage(
              fromMain: data?['fromMain'] ?? true,
              redirectRoute: data?['redirectRoute'],
            ),
            settings: RouteSettings(name: settings.name),
          );

        case "register":
          Map? data = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (_) => RegisterPage(
              fromMain: data?['fromMain'] ?? true,
              redirectRoute: data?['redirectRoute'],
            ),
            settings: RouteSettings(name: settings.name),
          );

        case "forgotpassword":
          return MaterialPageRoute(
            builder: (_) => ForgotPasswordPage(
              fromMain: settings.arguments == null ? true : false,
            ),
            settings: RouteSettings(name: settings.name),
          );


        default:
          return TransparentRoute(builder: (context) => PageMiddleware(settings.name, settings.arguments));
      }
    }
    return TransparentRoute(builder: (context) => PageMiddleware(settings.name, settings.arguments));
  }
}

/// NoTransitionRoute
/// Custom route which has no transitions
class NoTransitionRoute<T> extends MaterialPageRoute<T> {
  NoTransitionRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}

/// NoPushTransitionRoute
/// Custom route which has no transition when pushed, but has a pop animation
class NoPushTransitionRoute<T> extends CupertinoPageRoute<T> {
  NoPushTransitionRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // is popping
    if (animation.status == AnimationStatus.reverse) {
      return super.buildTransitions(context, animation, secondaryAnimation, child);
    }
    return child;
  }
}

/// NoPopTransitionRoute
/// Custom route which has no transition when popped, but has a push animation
class NoPopTransitionRoute<T> extends MaterialPageRoute<T> {
  NoPopTransitionRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // is pushing
    if (animation.status == AnimationStatus.forward) {
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    }
    return child;
  }
}

class RouteUtils {
  static RoutePredicate withNameLike(String name) {
    return (Route<dynamic> route) {
      return !route.willHandlePopInternally &&
          route is ModalRoute &&
          route.settings.name != null &&
          route.settings.name!.contains(name);
    };
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
