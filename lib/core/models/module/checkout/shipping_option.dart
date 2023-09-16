class SelectedShippingOption {
  List<ShippingOption>? shippingOptions;
  int? selectedShippingOption;
  bool? showShippingOption;

  SelectedShippingOption(
      {this.shippingOptions,
        this.selectedShippingOption,
        this.showShippingOption});

  SelectedShippingOption.fromJson(Map<String, dynamic> json) {
    if (json['shipping_options'] != null) {
      shippingOptions = <ShippingOption>[];
      json['shipping_options'].forEach((v) {
        shippingOptions!.add(new ShippingOption.fromJson(v));
      });
    }
    selectedShippingOption = json['selected_shipping_option'];
    showShippingOption = json['show_shipping_option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingOptions != null) {
      data['shipping_options'] =
          this.shippingOptions!.map((v) => v.toJson()).toList();
    }
    data['selected_shipping_option'] = this.selectedShippingOption;
    data['show_shipping_option'] = this.showShippingOption;
    return data;
  }
}

class ShippingOption {
  int? id;
  String? name;
  String? serviceDescription;
  double? shipCharge;
  String? formattedShipCharge;
  String? subText;

  ShippingOption(
      {this.id,
        this.name,
        this.serviceDescription,
        this.shipCharge,
        this.formattedShipCharge,
        this.subText});

  ShippingOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serviceDescription = json['service_description'];
    shipCharge = json['ship_charge'];
    formattedShipCharge = json['formatted_ship_charge'];
    subText = json['sub_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['service_description'] = this.serviceDescription;
    data['ship_charge'] = this.shipCharge;
    data['formatted_ship_charge'] = this.formattedShipCharge;
    data['sub_text'] = this.subText;
    return data;
  }
}