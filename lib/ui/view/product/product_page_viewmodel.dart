import 'package:bullion/services/api_request/page_request.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/services/shared/analytics_service.dart';

import '../../../../core/constants/module_type.dart';
import '../../../../locator.dart';
import '../../../../router.dart';

class ProductPageViewModel extends VGTSBaseViewModel {

  ScrollController scrollController = ScrollController();

  ProductDetails? _productDetail;

  ProductDetails? get productDetail =>
      pageSetting == null ? _productDetail : pageSetting!.productDetails;

  String? title = "";

  PageSettings? _pageSetting;

  PageSettings? get pageSetting => _pageSetting;

  List<ModuleSettings?>? get modules =>
      _pageSetting == null ? [] : _pageSetting!.moduleSetting;

  bool _showGradient = false;
  bool _showAppBar = false;

  bool get showGradient => _showGradient;

  set showGradient(bool value) {
    _showGradient = value;
    notifyListeners();
  }

  bool get showAppBar => _showAppBar;

  set showAppBar(bool value) {
    _showAppBar = value;
    notifyListeners();
  }

  String _path = '';

  ProductPageViewModel(ProductDetails? detail, String path){
    locator<EventBusService>().eventBus.registerTo<RefreshDataEvent>().listen((event) async{
      if(event.name == RefreshType.productRefresh) {
        init(_productDetail, _path);
      }
    });

    locator<EventBusService>().eventBus.registerTo<ProductApplyVariationEvent>().listen((event) async {
      init(event.product, event.refreshUrl);
    });

    init(detail,path);
    notifyListeners();
  }

  init(ProductDetails? detail, String path) async {
    _productDetail = detail;
    _path = path;

    setBusy(true);
    notifyListeners();

    print("PRODUCT URL ${path}");

    _pageSetting = await request(PageRequest.fetch(path: path));
    title = _pageSetting?.productDetails?.overview?.name ?? '';

    scrollController.addListener(() {
      if (scrollController.position.pixels > 50) {
        showAppBar = true;
      } else if (showAppBar) {
        showAppBar = false;
      }
    });

    locator<AnalyticsService>().logProductView(_pageSetting?.productDetails!);
    
    setBusy(false);
    notifyListeners();
  }

  onSearchClick() {
    locator<NavigationService>().pushNamed(Routes.search);
  }
}
