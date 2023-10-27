import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_detail/product_price.dart';
import 'package:bullion/core/models/module/product_detail/volume_prcing.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

class ProductDetailViewModel extends VGTSBaseViewModel {
  ProductDetails? _productDetails;

  int _activeIndex = 0;

  int get activeIndex => _activeIndex;

  set activeIndex(int value) {
    _activeIndex = value;
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
}
