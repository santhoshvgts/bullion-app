'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:bullion/services/api_request/page_request.dart';
import 'package:bullion/ui/shared/contentful/product/product_module.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../services/shared/eventbus_service.dart';

class ContentViewModel extends VGTSBaseViewModel {
  GlobalKey sortFilterWidgetKey = GlobalKey();
  bool showSortAppBarSection = false;

  ScrollController scrollController = ScrollController();
  ProductModuleController productModuleController = ProductModuleController();
  late Function(PageSettings?) onPageFetched;
  late Function(bool onload) onLoading;

  bool _sortFilterLoading = false;
  bool _paginationLoading = false;

  PageSettings? _pageSetting;

  PageSettings? get pageSetting => _pageSetting;

  ModuleSettings? productListingModule;

  ProductModel get productModel =>
      ProductModel.fromJson(productListingModule!.productModel);

  String? get productListingModuleTitle {
    return productModel.totalCountText;
  }

  List<ModuleSettings?>? get modules =>
      _pageSetting == null || sortFilterLoading
          ? []
          : _pageSetting!.moduleSetting;

  bool get sortFilterLoading => _sortFilterLoading;

  set sortFilterLoading(bool value) {
    _sortFilterLoading = value;
    notifyListeners();
  }

  bool get paginationLoading => _paginationLoading;

  set paginationLoading(bool value) {
    _paginationLoading = value;
    notifyListeners();
  }

  String _path = '';

  ContentViewModel(String path, Function(PageSettings?)? onPageFetched,
      PageSettings? initialValue, Function(bool name)? onLoading) {
    locator<EventBusService>()
        .eventBus
        .registerTo<RefreshDataEvent>()
        .listen((event) async {
      if (event.name == RefreshType.homeRefresh) {
        fetchContent(_path, refresh: true);
      }
    });

    init(path, onPageFetched, initialValue, onLoading);

    notifyListeners();
  }

  init(String path, Function(PageSettings?)? onPageFetched,
      PageSettings? initialValue, Function(bool name)? onLoading) async {
    scrollController.addListener(paginationFunction);

    _path = path;

    if (onPageFetched == null) {
      this.onPageFetched = (s) {
        print("EMPTY PAGE FETCHED");
      };
    } else {
      this.onPageFetched = onPageFetched;
    }

    if (onLoading == null) {
      this.onLoading = (s) {
        print("onChange");
      };
    } else {
      this.onLoading = onLoading;
    }

    this.onLoading(true);

    if (initialValue != null) {
      _pageSetting = initialValue;
      notifyListeners();
    }

    await fetchContent(path);

    this.onLoading(false);
  }

  Future<PageSettings?> fetchContent(String path,
      {bool refresh = false}) async {
    setBusy(true);
    notifyListeners();

    PageSettings? pageSettingData =
        await request<PageSettings>(PageRequest.fetch(path: path));
    notifyListeners();

    onPageFetched(pageSettingData);

    // if (refresh) {
    //   _pageSetting = null;
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }

    _pageSetting = pageSettingData;
    productListingModule = modules!.singleWhere(
        (element) => element!.moduleType == ModuleType.productList,
        orElse: () => null);

    setBusy(false);
    notifyListeners();

    return _pageSetting;
  }

  onSearchClick() {
    navigationService.pushNamed(Routes.search);
  }

  Future<ProductModel?> paginationFunction() async {
    listenAndToggleSortSection();

    // Checking the scroll reached the end
    if (scrollController.position.pixels <
            (scrollController.position.maxScrollExtent -
                (scrollController.position.pixels.toString().length * 50)) ||
        paginationLoading) {
      return null;
    }

    // Check if the Module List has Product Listing Module
    if (productListingModule != null) {
      if (paginationLoading) {
        return null;
      }

      ProductModel data =
          ProductModel.fromJson(productListingModule!.productModel);

      if (!data.hasNextPage!) {
        return null;
      }

      // Next Page Url
      String url = data.nextPageUrl!;

      paginationLoading = true;

      ModuleSettings? moduleSettings = await paginate(url);
      locator<AnalyticsService>().logScreenView(url);
      findAndReplaceModuleSetting(moduleSettings);

      paginationLoading = false;
    }

    return null;
  }

  Future<ModuleSettings?> paginate(String url) async {
    setBusy(true);
    notifyListeners();

    ModuleSettings? data =
        (await request<PageSettings>(PageRequest.paginate(path: url)))
            ?.productListingModule;

    setBusy(false);
    notifyListeners();

    // Trigger the paginate function in Product Module Controller that associate with
    // the product module
    // [Returns] next page product list fetch from api
    ProductModel productModel = ProductModel.fromJson(data?.productModel);

    // get the list of product already exists in product module
    List<ProductOverview> productList =
        ProductModel.fromJson(productListingModule?.productModel).products ??
            [];

    // insert existing products to new product list
    productModel.products?.insertAll(0, productList);

    data?.productModel = productModel.toJson();

    return data;
  }

  findAndReplaceModuleSetting(ModuleSettings? moduleSettings) async {
    // find the index of the product module
    int index = modules?.indexWhere(
            (element) => element?.moduleType == ModuleType.productList) ??
        0;

    // Remove and replace the module settings
    _pageSetting?.moduleSetting?.removeAt(index);
    _pageSetting?.moduleSetting?.insert(index, moduleSettings);

    // print("PRODUCT LENGTH ${moduleSettings.totalCount}");
    productListingModule = moduleSettings;
    productModuleController.onDataChange!(moduleSettings);
    notifyListeners();
  }

  onMetalChange(String targetUrl) async {
    onLoading(true);
    _pageSetting = null;
    await fetchContent(targetUrl);
    onLoading(false);
    notifyListeners();
  }

  timeFilterServiceListener(String type) async {
    // setBusy(true);
    // notifyListeners();
    //
    // String endPoint = _pageSetting!.slug! + "?type=${type}";
    //
    // _pageSetting = null;
    // _pageSetting = await locator<PageApi>().fetchPage(endPoint);
    //
    // setBusy(false);
    // notifyListeners();
  }

  onSortPressed() async {
    // ProductModel productModel = ProductModel.fromJson(productListingModule?.productModel);
    //
    // locator<AnalyticsService>().logScreenView("/list-sort", className: "list-sort");
    //
    // AlertResponse alertResponse = await locator<DialogService>().showBottomSheet(
    //     title: "Sort By",
    //     iconWidget: const Icon(Icons.sort),
    //     child: SortBottomSheet(productModel.sortOptions)
    // );
    //
    // if (alertResponse.status == true) {
    //   setBusy(true);
    //   notifyListeners();
    //
    //   ModuleSettings? data = await categoryApi!.filterProducts(alertResponse.data);
    //   locator<AnalyticsService>().logScreenView(alertResponse.data);
    //   findAndReplaceModuleSetting(data);
    //
    //   setBusy(false);
    //   notifyListeners();
    // }
  }

  onFilterPressed() async {
    // ProductModel productModel = ProductModel.fromJson(productListingModule?.productModel);
    //
    // FilterBottomSheetController controller = new FilterBottomSheetController();
    //
    // locator<AnalyticsService>().logScreenView("/list-filter", className: "list-filter");
    //
    // await locator<DialogService>().showBottomSheet(
    //     showActionBar: false,
    //     child: FilterBottomSheet(productModel, controller: controller, onSelect: (String? url) async {
    //       setBusy(true);
    //       notifyListeners();
    //
    //       ModuleSettings? data = await categoryApi!.filterProducts(url ?? '');
    //
    //       print("log URL ${url}");
    //       locator<AnalyticsService>().logScreenView(url);
    //
    //       findAndReplaceModuleSetting(data);
    //
    //       controller.onDataChange!(ProductModel.fromJson(data?.productModel));
    //
    //       setBusy(false);
    //       notifyListeners();
    //     },
    //   )
    // );
  }

  listenAndToggleSortSection() {
    if (productListingModule == null) {
      return;
    }

    RenderBox? box =
        sortFilterWidgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      Offset position =
          box.localToGlobal(Offset.zero); //this is global position
      double y = position.dy;

      if (y < 119 && !showSortAppBarSection) {
        showSortAppBarSection = true;
        notifyListeners();
      } else if (y > 120 && showSortAppBarSection) {
        showSortAppBarSection = false;
        notifyListeners();
      }
    }
  }
}
