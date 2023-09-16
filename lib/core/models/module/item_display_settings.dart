import 'package:flutter/material.dart';
import 'package:bullion/helper/utils.dart';

class ItemDisplaySettings {
  String displayType = "standard";
  String displayTypeVariation = "standard";
  String displayDirection = "vertical";
  String contentAlignment = "left";
  String titleAlignment = "center";
  String? _textColor;
  String titleStyle = "medium";
  String contentStyle = "small";
  String? _backgroundColor;
  String imagePosition = "center";
  String imageShape = "standard";
  String? _imageWidth;
  String actionsAlignment = "left";
  String actionsWidth = "auto";
  bool hasBoxShadow = false;
  bool hasRoundedCorners = false;
  bool hasBorders = false;
  bool hasContentHasBackground = false;
  String? _gridCols;
  bool wrapItems = false;
  bool fullBleed = false;
  String cardSize = "small";
  bool collpasable = false;
  String? _itemAlignment = "spaceBetween";

  double get cardPadding {
    switch(cardSize){
      case "mini":
        return 2.0;
      case "small":
        return 8.0;
      case "medium":
        return 15.0;
      case "large":
        return 25.0;
      default:
        return 0;
    }

  }

  int get gridCols => (_gridCols == null || _gridCols == '') ? 2 : int.parse(_gridCols!);

  double? get imageWidth {

    if (_imageWidth == "auto"){
      return null;
    }

    if (_imageWidth == null || _imageWidth == ''){
      return double.infinity;
    }
    return double.parse(_imageWidth!);
  }

  double? get imageHeight {
    return imageWidth == double.infinity ? null : imageWidth;
  }

  Color get textColor => getColorFromString(_textColor, fallbackColor: Colors.black);

  Color get backgroundColor => getColorFromString(_backgroundColor);

  MainAxisAlignment get itemMainAxisAlignment {
    switch(_itemAlignment){
      case "center":
        return MainAxisAlignment.center;
      default:
        return MainAxisAlignment.spaceBetween;
    }
  }


  ItemDisplaySettings();

  ItemDisplaySettings.fromJson(Map<String, dynamic> json) {
    displayType = json['display_type'] ?? displayType;
    displayTypeVariation = json['display_type_variation'] ?? displayTypeVariation;
    displayDirection = json['display_direction'] ?? displayDirection;
    contentAlignment = json['content_alignment'] ?? contentAlignment;
    titleAlignment = json['title_alignment'] ?? titleAlignment;
    _textColor = json['text_color'] ?? _textColor;
    titleStyle = json['title_style'] ?? titleStyle;
    contentStyle = json['content_style'] ?? contentStyle;
    _backgroundColor = json['background_color'] ?? _backgroundColor;
    imagePosition = json['image_position'] ?? imagePosition;
    imageShape = json['image_shape'] ?? imageShape;
    _imageWidth = json['image_width'] ?? _imageWidth;
    _itemAlignment = json['item_alignment'] ?? _itemAlignment;
    actionsAlignment = json['actions_alignment'] ?? actionsAlignment;
    actionsWidth = json['actions_width'] ?? actionsWidth;
    hasBoxShadow = json['has_box_shadow'] ?? hasBoxShadow;
    hasRoundedCorners = json['has_rounded_corners'] ?? hasRoundedCorners;
    hasBorders = json['has_borders'] ?? hasBorders;
    hasContentHasBackground = json['has_content_has_background'] ?? hasContentHasBackground;
    _gridCols = json['grid_cols'] ?? _gridCols;
    wrapItems = json['wrap_items'] ?? wrapItems;
    fullBleed = json['full_bleed'] ?? fullBleed;
    cardSize = json['card_size'] ?? cardSize;
    collpasable = json['collpasable'] ?? collpasable;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_type'] = this.displayType;
    data['display_type_variation'] = this.displayTypeVariation;
    data['display_direction'] = this.displayDirection;
    data['content_alignment'] = this.contentAlignment;
    data['title_alignment'] = this.titleAlignment;
    data['text_color'] = this.textColor;
    data['title_style'] = this.titleStyle;
    data['content_style'] = this.contentStyle;
    data['background_color'] = this._backgroundColor;
    data['image_position'] = this.imagePosition;
    data['image_shape'] = this.imageShape;
    data['image_width'] = this._imageWidth;
    data['item_alignment'] = this._itemAlignment;
    data['actions_alignment'] = this.actionsAlignment;
    data['actions_width'] = this.actionsWidth;
    data['has_box_shadow'] = this.hasBoxShadow;
    data['has_rounded_corners'] = this.hasRoundedCorners;
    data['has_borders'] = this.hasBorders;
    data['has_content_has_background'] = this.hasContentHasBackground;
    data['grid_cols'] = this._gridCols;
    data['wrap_items'] = this.wrapItems;
    data['full_bleed'] = this.fullBleed;
    data['card_size'] = this.cardSize;
    data['collpasable'] = this.collpasable;
    return data;
  }
}