import 'package:bullion/core/models/module/product_detail/competitor_price.dart';
import 'package:bullion/core/models/module/product_detail/product_picture.dart';
import 'package:bullion/core/models/module/product_detail/product_variant.dart';
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
  List<ProductPicture>? productPictures;
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

  List<CompetitorPrice>? competitorPrices;
  List<ProductVariant>? productVariants;

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
    _coinGradeSpecification = cgSpecification as List<Specifications>? ?? [];
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
        volumePricing!.add(VolumePricing.fromJson(v));
      });
    }
    volumePricingHelpText = json['volume_pricing_help_text'];
    productVideos = json['product_videos'];
    description = json['description'];
    productReviews = json['product_reviews'] != null
        ? ProductReviews.fromJson(json['product_reviews'])
        : null;

    if (json['product_pictures'] != null) {
      productPictures = <ProductPicture>[];
      json['product_pictures'].forEach((v) {
        productPictures!.add(ProductPicture.fromJson(v));
      });
    }

    if (json['coin_grade_specification'] != null) {
      _coinGradeSpecification = <Specifications>[];
      json['coin_grade_specification'].forEach((v) {
        _coinGradeSpecification.add(Specifications.fromJson(v));
      });
    }

    if (json['competitor_prices'] != null) {
      competitorPrices = <CompetitorPrice>[];
      json['competitor_prices'].forEach((v) {
        competitorPrices!.add(new CompetitorPrice.fromJson(v));
      });
    }

    if (json['specifications'] != null) {
      specifications = <Specifications>[];
      json['specifications'].forEach((v) {
        specifications!.add(Specifications.fromJson(v));
      });
    }

    if (json['product_variants'] != null) {
      productVariants = <ProductVariant>[];
      json['product_variants'].forEach((v) {
        productVariants!.add(new ProductVariant.fromJson(v));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_id'] = productId;
    if (overview != null) {
      data['overview'] = overview!.toJson();
    }
    if (volumePricing != null) {
      data['volume_pricing'] =
          volumePricing!.map((v) => v.toJson()).toList();
    }
    data['volume_pricing_help_text'] = volumePricingHelpText;
    data['product_pictures'] = productPictures;
    data['product_videos'] = productVideos;
    data['description'] = description;
    if (productReviews != null) {
      data['product_reviews'] = productReviews!.toJson();
    }
    if (_coinGradeSpecification != null) {
      data['coin_grade_specification'] = _coinGradeSpecification.map((v) => v.toJson()).toList();
    }
    if (specifications != null) {
      data['specifications'] = specifications!.map((v) => v.toJson()).toList();
    }

    if (productPictures != null) {
      data['product_pictures'] = productPictures!.map((v) => v.toJson()).toList();
    }

    if (productVariants != null) {
      data['product_variants'] = productVariants!.map((v) => v.toJson()).toList();
    }

    if (competitorPrices != null) {
      data['competitor_prices'] = competitorPrices!.map((v) => v.toJson()).toList();
    }

    data['price_badge_text'] = priceBadgeText;
    data['product_notes'] = productNotes;
    data['image_note'] = imageNote;
    data['requested_qty'] = requestedQty;
    data['posted_date'] = postedDate;
    data['formated_posted_date'] = formatedPostedDate;
    data['is_new'] = isNew;
    data['formatted_your_price'] = formatedYourPrice;
    data['your_price'] = yourPrice;

    data['is_in_user_wish_list'] = _isInUserWishList;
    data['is_in_user_price_alert'] = _isInUserPriceAlert;
    data['is_in_user_alert_me'] = _isInUserAlertMe;

    return data;
  }


}


