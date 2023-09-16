import 'package:collection/collection.dart' show IterableExtension;
import 'package:bullion/core/models/module/product_detail/product_reviews.dart';
import 'package:bullion/core/models/module/product_detail/specifications.dart';
import 'package:bullion/core/models/module/product_detail/volume_prcing.dart';
import 'package:bullion/core/models/module/product_item.dart';

class ProductDetails {
  int? productId;
  ProductOverview? overview;
  int? requestedQty;
  List<VolumePricing>? volumePricing;
  String? volumePricingHelpText;
  List<String>? productPictures;
  dynamic productVideos;
  String? description;
  ProductReviews? productReviews;
  List<Specifications> _coinGradeSpecification = [];
  List<Specifications>? specifications;
  String? priceBadgeText;
  List<String>? productNotes;
  String? imageNote;
  String? postedDate;
  String? formatedPostedDate;
  bool? isNew;
  double? yourPrice;
  String? formatedYourPrice;

  bool? _isInUserWishList;
  bool? _isInUserPriceAlert;
  bool? _isInUserAlertMe;

  bool get enableUserWishList => _isInUserWishList != null;
  bool get enableUserPriceAlert {
    print(_isInUserPriceAlert);
    return _isInUserPriceAlert != null;
  }
  bool get enableUserAlertMe => _isInUserAlertMe != null;

  bool? get isInUserWishList => _isInUserWishList == null ? false : _isInUserWishList;

  bool? get isInUserPriceAlert => _isInUserPriceAlert == null ? false : _isInUserPriceAlert;

  bool? get isInUserAlertMe => _isInUserAlertMe == null ? false : _isInUserAlertMe;

  set isInUserWishList(bool? value) {
    _isInUserWishList = value;
  }

  set isInUserPriceAlert(bool? value) {
    _isInUserPriceAlert = value;
  }

  set isInUserAlertMe(bool? value) {
    _isInUserAlertMe = value;
  }

  List<Specifications> get coinGradeSpecification {
    return _coinGradeSpecification.where((element) => element.key != "Header" && element.key != "Footer").toList();
  }

  Specifications? get coinHeaderSpecification {
    return _coinGradeSpecification.singleWhereOrNull((element) => element.key == "Header");
  }

  Specifications? get coinFooterSpecification {
    return _coinGradeSpecification.singleWhereOrNull((element) => element.key == "Footer");
  }

  ProductDetails(
      {this.productId,
        this.overview,this.requestedQty,
        this.volumePricing,
        this.volumePricingHelpText,
        this.productPictures,
        this.productVideos,
        this.description,
        this.productReviews,
        List? cgSpecification,
        this.specifications,
        this.priceBadgeText,
        this.productNotes,
        this.imageNote,
        this.postedDate,
        this.formatedPostedDate,
        this.isNew,this.yourPrice,this.formatedYourPrice
      }){
    this._coinGradeSpecification = cgSpecification as List<Specifications>? ?? [];
  }
  ProductDetails.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];

    if (json['overview'] != null){
      overview =  ProductOverview.fromJson(json['overview']);
    } else if (json['product_overview'] != null){
      overview =  ProductOverview.fromJson(json['product_overview']);
    } else {
      overview = null;
    }

    if (json['volume_pricing'] != null) {
      volumePricing = <VolumePricing>[];
      json['volume_pricing'].forEach((v) {
        volumePricing!.add(new VolumePricing.fromJson(v));
      });
    }
    volumePricingHelpText = json['volume_pricing_help_text'];
    productPictures = json['product_pictures']==null ? null : json['product_pictures'].cast<String>();
    productVideos = json['product_videos'];
    description = json['description'];
    productReviews = json['product_reviews'] != null
        ? new ProductReviews.fromJson(json['product_reviews'])
        : null;

    if (json['coin_grade_specification'] != null) {
      _coinGradeSpecification = <Specifications>[];
      json['coin_grade_specification'].forEach((v) {
        _coinGradeSpecification.add(new Specifications.fromJson(v));
      });
    }

    if (json['specifications'] != null) {
      specifications = <Specifications>[];
      json['specifications'].forEach((v) {
        specifications!.add(new Specifications.fromJson(v));
      });
    }
    priceBadgeText = json['price_badge_text'];

    _isInUserWishList = json['is_in_user_wish_list'];
    _isInUserPriceAlert = json['is_in_user_price_alert'];
    _isInUserAlertMe = json['is_in_user_alert_me'];

    productNotes = json['product_notes'] == null ? null : json['product_notes'].cast<String>();
    imageNote = json['image_note'];
    requestedQty = json['requested_qty'];
    postedDate = json['posted_date'];
    formatedPostedDate = json['formated_posted_date'];
    isNew = json['is_new'];
    yourPrice = json['your_price'];
    formatedYourPrice = json['formatted_your_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    if (this.overview != null) {
      data['overview'] = this.overview!.toJson();
    }
    if (this.volumePricing != null) {
      data['volume_pricing'] =
          this.volumePricing!.map((v) => v.toJson()).toList();
    }
    data['volume_pricing_help_text'] = this.volumePricingHelpText;
    data['product_pictures'] = this.productPictures;
    data['product_videos'] = this.productVideos;
    data['description'] = this.description;
    if (this.productReviews != null) {
      data['product_reviews'] = this.productReviews!.toJson();
    }
    if (this._coinGradeSpecification != null) {
      data['coin_grade_specification'] = this._coinGradeSpecification.map((v) => v.toJson()).toList();
    }
    if (this.specifications != null) {
      data['specifications'] = this.specifications!.map((v) => v.toJson()).toList();
    }
    data['price_badge_text'] = this.priceBadgeText;
    data['product_notes'] = this.productNotes;
    data['image_note'] = this.imageNote;
    data['requested_qty'] = this.requestedQty;
    data['posted_date'] = this.postedDate;
    data['formated_posted_date'] = this.formatedPostedDate;
    data['is_new'] = this.isNew;
    data['formatted_your_price'] = this.formatedYourPrice;
    data['your_price'] = this.yourPrice;

    data['is_in_user_wish_list'] = this._isInUserWishList;
    data['is_in_user_price_alert'] = this._isInUserPriceAlert;
    data['is_in_user_alert_me'] = this._isInUserAlertMe;

    return data;
  }


}


