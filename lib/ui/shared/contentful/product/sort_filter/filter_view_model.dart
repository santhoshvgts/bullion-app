import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:bullion/core/models/module/product_listing/filter_module.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';

class FilterViewModel extends VGTSBaseViewModel {

  ProductModel productModel;

  String? selectedFacetName;

  Facets? get selectedFacet => filterData?.singleWhereOrNull((element) => element.facetName == selectedFacetName);

  List<Facets>? get filterData => productModel.facets;

  FilterViewModel(this.productModel){
    onFilterSectionChange(0);
  }

  void onFilterSectionChange(int index) {
    selectedFacetName = filterData?.isEmpty == true ? '' : filterData?[index].facetName;
    notifyListeners();
  }

  onDataChange(ProductModel productModel) {
    this.productModel = productModel;
    notifyListeners();
  }

}