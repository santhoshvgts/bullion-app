
import 'package:flutter/material.dart';
import 'package:bullion/helper/utils.dart';

import 'item_display_settings.dart';

class DisplaySettings {
  String titleAlignment = "left";
  String titleStyle = "medium";
  String _backgroundColor = "none";
  String? backgroundImageUrl;
  String actionButtonsPosition = "right";
  String displayStyle = "standard";
  String? _textColor;
  bool fullBleed = false;
  String? _marginTop;
  ItemDisplaySettings itemDisplaySettings = ItemDisplaySettings();

  double get marginTop {
    if (_marginTop == "none" || _marginTop == null){
      return 0;
    }

    if (_marginTop == "default"){
      return 10;
    }

    return double.parse(_marginTop!);
  }

  bool get hasBackgroundImage => backgroundImageUrl != null && backgroundImageUrl != "none" && backgroundImageUrl != "";

  // Cross Axis Alignment
  CrossAxisAlignment get titleCrossAxisAlignment {
    switch(titleAlignment){
      case "right":
        return CrossAxisAlignment.end;
      case "left":
        return CrossAxisAlignment.start;
      case "center":
        return CrossAxisAlignment.center;
      default:
        return CrossAxisAlignment.start;
    }
  }

  Color get backgroundColor => getColorFromString(_backgroundColor, fallbackColor: Colors.white);

  Color get textColor => getColorFromString(_textColor, fallbackColor: Colors.black);

  DisplaySettings.fromJson(Map<String, dynamic> json) {
    titleAlignment = json['title_alignnment'] ?? titleAlignment;
    titleStyle = json['title_style'] ?? titleStyle;
    _backgroundColor = json['background_color'] ?? _backgroundColor;
    backgroundImageUrl = json['background_image_url'] ?? backgroundImageUrl;
    actionButtonsPosition = json['action_buttons_position'] ?? actionButtonsPosition;
    displayStyle = json['display_style'] ?? displayStyle;
    _textColor = json['text_color'] ?? _textColor;
    fullBleed = json['full_bleed'] ?? fullBleed;
    _marginTop = json['margin_top'] ?? _marginTop;

    if (json['item_display_settings'] != null) {
      itemDisplaySettings = ItemDisplaySettings.fromJson(json['item_display_settings']);
    } else {
      itemDisplaySettings = ItemDisplaySettings();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title_alignnment'] = this.titleAlignment;
    data['title_style'] = this.titleStyle;
    data['background_color'] = this._backgroundColor;
    data['background_image_url'] = this.backgroundImageUrl;
    data['action_buttons_position'] = this.actionButtonsPosition;
    data['display_style'] = this.displayStyle;
    data['text_color'] = this._textColor;
    data['full_bleed'] = this.fullBleed;
    data['margin_top'] = this._marginTop;
    if (this.itemDisplaySettings != null) {
      data['item_display_settings'] = this.itemDisplaySettings.toJson();
    }
    return data;
  }
}