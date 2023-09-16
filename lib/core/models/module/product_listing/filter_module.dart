

import 'items.dart';

class Facets {
  String? facetName;
  String? displayName;
  List<Items>? items;
  bool? hasSelectedItems;

  Facets(
      {this.facetName, this.displayName, this.items, this.hasSelectedItems});

  Facets.fromJson(Map<String, dynamic> json) {
    facetName = json['facet_name'];
    displayName = json['display_name'];
    items = [];
    if (json['items'] != null) {
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    hasSelectedItems = json['has_selected_items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facet_name'] = this.facetName;
    data['display_name'] = this.displayName;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['has_selected_items'] = this.hasSelectedItems;
    return data;
  }
}
