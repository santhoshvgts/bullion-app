import 'package:bullion/core/models/module/action_button.dart';
import 'package:bullion/core/models/module/display_settings.dart';
import 'package:bullion/core/models/module/meta_data.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';

class ModuleSettings {
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
        ? new MetaData.fromJson(json['meta_data'])
        : null;
    if (json['actions'] != null) {
      actions = <ActionButton>[];
      json['actions'].forEach((v) {
        actions!.add(new ActionButton.fromJson(v));
      });
    }
    productModel = json['product_model'];
    items = json['items'];
    dynamicItemData = json['item_data'];
    itemData = json['item_data_as_object'];
    displaySettings = json['display_settings'] != null
        ? new DisplaySettings.fromJson(json['display_settings'])
        : null;
    slug = json['slug'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_type'] = this.moduleType;
    data['item_source'] = this.itemSource;
    data['display_type'] = this.displayType;
    data['display_order'] = this.displayOrder;
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['items'] = this.items;
    data['item_data'] = this.dynamicItemData;
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.toJson();
    }
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    if (this.displaySettings != null) {
      data['display_settings'] = this.displaySettings!.toJson();
    }
    data['product_model'] = this.productModel;
    data['item_data_as_object'] = this.itemData;
    data['slug'] = this.slug;

    return data;
  }
}
