import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_detail/product_price.dart';
import 'package:bullion/core/models/module/product_detail/volume_prcing.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../helper/utils.dart';
import '../../../../../router.dart';
import '../../../../../services/shared/navigator_service.dart';

import '../../../../../services/api_request/favorites_request.dart';

class ProductDetailViewModel extends VGTSBaseViewModel {
  ProductDetails? _productDetails;

  SwiperController productImageController = SwiperController();

  int _activeIndex = 0;

  int get activeIndex => _activeIndex;

  set activeIndex(int value) {
    _activeIndex = value;
    notifyListeners();
  }

  int _detailTapSectionIndex = 0;

  int get detailTapSectionIndex => _detailTapSectionIndex;

  set detailTapSectionIndex(int value) {
    _detailTapSectionIndex = value;
    notifyListeners();
  }

  String? _slug;

  String? get slug => _slug;

  ProductDetails? get productDetails => _productDetails;

  ProductOverview? _productOverview;

  ProductOverview? get productOverview =>
      productDetails == null ? _productOverview : productDetails!.overview;

  VolumePricing? _selectedVolumePricing;

  VolumePricing? get selectedVolumePricing =>
      _selectedVolumePricing ?? productDetails?.volumePricing?.firstOrNull;

  set selectedVolumePricing(VolumePricing? value) {
    _selectedVolumePricing = value;
    notifyListeners();
  }

  ProductPricesByPaymentType? _selectedPaymentType;

  ProductPricesByPaymentType? get selectedPaymentType =>
      _selectedPaymentType ??
      productDetails
          ?.volumePricing?.firstOrNull?.productPricesByPaymentType?.firstOrNull;

  set selectedPaymentType(ProductPricesByPaymentType? value) {
    _selectedPaymentType = value;
    notifyListeners();
  }

  void init(ProductDetails? setting, {String? slug}) {
    _productDetails = setting;
    _slug = slug;

    notifyListeners();
  }

  addToCart() {
    locator<CartService>()
        .addItemToCart(_productDetails!.overview!.productId, 1);
  }

  void priceAlert(ProductOverview? overview, BuildContext context) {
    if (authenticationService!.isAuthenticated) {
      locator<NavigationService>()
          .pushNamed(Routes.editPriceAlert, arguments: {
        "productDetails": overview
      });
    } else {
      Util.showSnackBar(context,
          "Please login to create a Price Alert");
    }
  }



  Future<void> addAsFavorite(int? productId) async {
    setBusy(true);
    if (!authenticationService.isAuthenticated) {
       return;
    }
    var response;

    if (productDetails!.isInUserWishList!) {

    } else {
      response =  await request<ProductDetails>(FavoritesRequest.addFavorite(productId.toString()));
      productDetails!.isInUserWishList = response;

    }

    setBusy(false);
  }
}
