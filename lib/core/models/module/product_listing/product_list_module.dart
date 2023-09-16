import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/models/module/product_listing/sort_module.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';

import 'filter_module.dart';

class ProductModel {
  List<ProductOverview>? products;
  int? totalCount;
  int? pageSize;
  List<Facets>? facets;
  String? didYouMean;
  String? totalCountText;
  String? resetFilterUrl;
  String? nextPageUrl;
  bool? hasNextPage;
  bool? queryError;
  List<SelectedItemList>? pageSizeOptions;
  List<SelectedItemList>? sortOptions;
  List<SelectedItemList>? viewOptions;
  int? categoryType;
  int? categoryId;
  int? selectedFacetsCount;

  ProductModel(
      {this.products,
        this.totalCount,
        this.pageSize,
        this.facets,
        this.didYouMean,
        this.resetFilterUrl,
        this.totalCountText,
        this.nextPageUrl,
        this.hasNextPage,
        this.queryError,
        this.pageSizeOptions,
        this.sortOptions,
        this.viewOptions,
        this.categoryType,
        this.categoryId});

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductOverview>[];
      json['products'].forEach((v) {
        products!.add(new ProductOverview.fromJson(v));
      });
    }
    totalCount = json['total_count'];
    totalCountText = json['total_count_text'];
    selectedFacetsCount = json['selected_facets_count'];
    pageSize = json['page_size'];
    if (json['facets'] != null) {
      facets = <Facets>[];
      json['facets'].forEach((v) {
        facets!.add(new Facets.fromJson(v));
      });
    }
    didYouMean = json['did_you_mean'];
    resetFilterUrl = json['reset_filter_url'];
    nextPageUrl = json['next_page_url'];
    hasNextPage = json['has_next_page'];
    queryError = json['query_error'];
    if (json['page_size_options'] != null) {
      pageSizeOptions = <SelectedItemList>[];
      json['page_size_options'].forEach((v) {
        pageSizeOptions!.add(new SelectedItemList.fromJson(v));
      });
    }
    if (json['sort_options'] != null) {
      sortOptions = <SelectedItemList>[];
      json['sort_options'].forEach((v) {
        sortOptions!.add(new SelectedItemList.fromJson(v));
      });
    }
    if (json['view_options'] != null) {
      viewOptions = <SelectedItemList>[];
      json['view_options'].forEach((v) {
        viewOptions!.add(new SelectedItemList.fromJson(v));
      });
    }
    categoryType = json['category_type'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['total_count'] = this.totalCount;
    data['total_count_text'] = this.totalCountText;
    data['selected_facets_count'] = this.selectedFacetsCount;
    data['page_size'] = this.pageSize;
    if (this.facets != null) {
      data['facets'] = this.facets!.map((v) => v.toJson()).toList();
    }
    data['did_you_mean'] = this.didYouMean;
    data['reset_filter_url'] = this.resetFilterUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['has_next_page'] = this.hasNextPage;
    data['query_error'] = this.queryError;
    if (this.pageSizeOptions != null) {
      data['page_size_options'] =
          this.pageSizeOptions!.map((v) => v.toJson()).toList();
    }
    if (this.sortOptions != null) {
      data['sort_options'] = this.sortOptions!.map((v) => v.toJson()).toList();
    }
    if (this.viewOptions != null) {
      data['view_options'] = this.viewOptions!.map((v) => v.toJson()).toList();
    }
    data['category_type'] = this.categoryType;
    data['category_id'] = this.categoryId;
    return data;
  }
}