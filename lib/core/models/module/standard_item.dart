import 'package:flutter/material.dart';
import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/action_button.dart';
import 'package:bullion/helper/utils.dart';

class StandardItem {
  String? title;
  String? subtitle;
  String? content;
  String? targetUrl;
  String? imageUrl;
  String contentType = ContentType.text;
  List<ActionButton>? actions;
  String? _backgroundColor;

  Color get backgroundColor => getColorFromString(_backgroundColor);

  bool get hasContent => title != null || subtitle != null || content != null;

  StandardItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    content = json['content'];
    targetUrl = json['target_url'];
    imageUrl = json['image_url'];
    contentType = json['content_type'] ?? contentType;
    if (json['actions'] != null) {
      actions = <ActionButton>[];
      json['actions'].forEach((v) {
        actions!.add(ActionButton.fromJson(v));
      });
    }
    _backgroundColor = json['background_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['content'] = this.content;
    data['target_url'] = this.targetUrl;
    data['image_url'] = this.imageUrl;
    data['content_type'] = this.contentType;
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    data['background_color'] = this._backgroundColor;
    return data;
  }
}
