import 'package:bullion/core/models/module/product_detail/review.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';

class ProductReviews {
  List<SelectedItemList>? sortOptions;
  SelectedItemList? selectedSort;
  int? productId;
  String? avgRatingPercentage;
  double? avgRatings;
  int? reviewCount;
  List<Reviews>? reviews;

  ProductReviews(
      {this.sortOptions,
        this.selectedSort,
        this.productId,
        this.avgRatingPercentage,
        this.avgRatings,
        this.reviewCount,
        this.reviews});

  ProductReviews.fromJson(Map<String, dynamic> json) {
    if (json['sort_options'] != null) {
      sortOptions = <SelectedItemList>[];
      json['sort_options'].forEach((v) {
        sortOptions!.add(new SelectedItemList.fromJson(v));
      });
    }
    selectedSort = json['selected_sort'] != null ? new SelectedItemList.fromJson(json['selected_sort']) : null;
    productId = json['product_id'];
    avgRatingPercentage = json['avg_rating_percentage'];
    avgRatings = json['avg_ratings'];
    reviewCount = json['review_count'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sortOptions != null) {
      data['sort_options'] = this.sortOptions!.map((v) => v.toJson()).toList();
    }
    data['selected_sort'] = this.selectedSort;
    data['product_id'] = this.productId;
    data['avg_rating_percentage'] = this.avgRatingPercentage;
    data['avg_ratings'] = this.avgRatings;
    data['review_count'] = this.reviewCount;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



