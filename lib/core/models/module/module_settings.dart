// ignore_for_file: avoid_print, must_be_immutable

import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/action_button.dart';
import 'package:bullion/core/models/module/display_settings.dart';
import 'package:bullion/core/models/module/meta_data.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';

class ModuleSettings extends BaseModel {
  String? moduleType;
  String? itemSource;
  String? displayType;
  int? displayOrder;
  String? id;
  String? title;
  String? subtitle;
  MetaData? metaData;
  List<ActionButton>? actions;
  DisplaySettings? displaySettings;
  List<dynamic>? items;
  List<dynamic>? dynamicItemData;
  dynamic itemData;
  dynamic productModel;

  String? slug;

  bool get hasHeaderSection => title != null || subtitle != null || hasActionButton;

  bool get hasActionButton {
    if(actions == null) {
      return false;
    }
    return actions!.isNotEmpty;
  }

  ModuleSettings(
      {this.moduleType,this.itemSource,this.displayType,
        this.displayOrder,
        this.id,
        this.title,
        this.subtitle,
        this.metaData,
        this.actions,
        this.displaySettings});

  setProductModel(ProductModel productModel){
    print("Product Length");
    print(productModel.products!.length);
    this.productModel = productModel.toJson();
  }

  

  ModuleSettings.fromJson(Map<String, dynamic> json) {
    moduleType = json['module_type'];
    itemSource = json["item_source"];
    displayType = json["display_type"];
    displayOrder = json['display_order'];
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    metaData = json['meta_data'] != null
        ? MetaData.fromJson(json['meta_data'])
        : null;
    if (json['actions'] != null) {
      actions = <ActionButton>[];
      json['actions'].forEach((v) {
        actions!.add(ActionButton.fromJson(v));
      });
    }
    productModel = json['product_model'];
    items = json['items'];
    dynamicItemData = json['item_data'];
    itemData = json['item_data_as_object'];
    displaySettings = json['display_settings'] != null
        ? DisplaySettings.fromJson(json['display_settings'])
        : null;
    slug = json['slug'];

  }

    @override
      ModuleSettings fromJson(json) => ModuleSettings.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_type'] = moduleType;
    data['item_source'] = itemSource;
    data['display_type'] = displayType;
    data['display_order'] = displayOrder;
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['items'] = items;
    data['item_data'] = dynamicItemData;
    if (metaData != null) {
      data['meta_data'] = metaData!.toJson();
    }
    if (actions != null) {
      data['actions'] = actions!.map((v) => v.toJson()).toList();
    }
    if (displaySettings != null) {
      data['display_settings'] = displaySettings!.toJson();
    }
    data['product_model'] = productModel;
    data['item_data_as_object'] = itemData;
    data['slug'] = slug;

    return data;
  }
}
