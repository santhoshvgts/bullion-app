import 'package:bullion/core/models/module/selected_item_list.dart';
import 'package:bullion/helper/utils.dart';

class Portfolio {
  bool? isEnabled;
  double? totalAcquisitionCost;
  String? formattedTotalAcquisitionCost;
  double? totalCurrentValue;
  String? formattedTotalCurrentValue;
  List<MetalHoldings>? metalHoldings;
  List<SelectedItemList>? timePeriodOptions;
  List<PortfolioChartData>? chartData;
  String? disclaimer;
  double? change;
  String? formattedChange;
  double? changePercentage;

  Portfolio(
      {this.isEnabled,
      this.totalAcquisitionCost,
      this.formattedTotalAcquisitionCost,
      this.totalCurrentValue,
      this.formattedTotalCurrentValue,
      this.metalHoldings,
      this.timePeriodOptions,
      this.chartData,
      this.disclaimer,
      this.change,
      this.changePercentage,
      this.formattedChange});

  Portfolio.fromJson(Map<String, dynamic> json) {
    isEnabled = json['is_enabled'];
    totalAcquisitionCost = json['total_acquisition_cost'];
    formattedTotalAcquisitionCost = json['formatted_total_acquisition_cost'];
    totalCurrentValue = json['total_current_value'];
    formattedTotalCurrentValue = json['formatted_total_current_value'];
    if (json['metal_holdings'] != null) {
      metalHoldings = <MetalHoldings>[];
      json['metal_holdings'].forEach((v) {
        metalHoldings!.add(new MetalHoldings.fromJson(v));
      });
    }
    if (json['time_period_options'] != null) {
      timePeriodOptions = <SelectedItemList>[];
      json['time_period_options'].forEach((v) {
        timePeriodOptions!.add(new SelectedItemList.fromJson(v));
      });
    }
    if (json['portfolio_chart_model'] != null) {
      chartData = <PortfolioChartData>[];
      json['portfolio_chart_model'].forEach((v) {
        chartData!.add(new PortfolioChartData.fromJson(v));
      });
    }

    disclaimer = json['disclaimer'];
    change = json['change'];
    changePercentage = json['change_percentage'];
    formattedChange = json['formatted_change'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_enabled'] = this.isEnabled;
    data['total_acquisition_cost'] = this.totalAcquisitionCost;
    data['formatted_total_acquisition_cost'] =
        this.formattedTotalAcquisitionCost;
    data['total_current_value'] = this.totalCurrentValue;
    data['formatted_total_current_value'] = this.formattedTotalCurrentValue;
    if (this.metalHoldings != null) {
      data['metal_holdings'] =
          this.metalHoldings!.map((v) => v.toJson()).toList();
    }
    if (this.timePeriodOptions != null) {
      data['time_period_options'] =
          this.timePeriodOptions!.map((v) => v.toJson()).toList();
    }

    if (this.chartData != null) {
      data['portfolio_chart_model'] =
          this.chartData!.map((v) => v.toJson()).toList();
    }

    data['disclaimer'] = this.disclaimer;
    data['change'] = this.change;
    data['change_percentage'] = this.changePercentage;
    data['formatted_change'] = this.formattedChange;
    return data;
  }
}

class MetalHoldings {
  int? metalId;
  String? metalName;
  String? metalColorCode;
  int? quantity;
  double? acquisitionCost;
  String? formattedAcquisitionCost;
  double? currentValue;
  String? formattedCurrentValue;
  double? metalContent;
  String? formattedMetalContent;
  double? totalPercentageInPortfolio;

  String? get formattedMetalCount {
    int count = Util.getDecimalPlaces(metalContent);
    return count == 0
        ? metalContent?.round().toString()
        : metalContent.toString();
  }

  MetalHoldings(
      {this.metalId,
      this.metalName,
      this.metalColorCode,
      this.quantity,
      this.acquisitionCost,
      this.formattedAcquisitionCost,
      this.currentValue,
      this.formattedCurrentValue,
      this.metalContent,
      this.formattedMetalContent,
      this.totalPercentageInPortfolio});

  MetalHoldings.fromJson(Map<String, dynamic> json) {
    metalId = json['metal_id'];
    metalName = json['metal_name'];
    metalColorCode = json['metal_color_code'];
    quantity = json['quantity'];
    acquisitionCost = json['acquisition_cost'];
    formattedAcquisitionCost = json['formatted_acquisition_cost'];
    currentValue = json['current_value'];
    formattedCurrentValue = json['formatted_current_value'];
    metalContent = json['metal_content'];
    formattedMetalContent = json['formatted_metal_content'];
    totalPercentageInPortfolio = json['total_percentage_in_portfolio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['metal_id'] = this.metalId;
    data['metal_name'] = this.metalName;
    data['metal_color_code'] = this.metalColorCode;
    data['quantity'] = this.quantity;
    data['acquisition_cost'] = this.acquisitionCost;
    data['formatted_acquisition_cost'] = this.formattedAcquisitionCost;
    data['current_value'] = this.currentValue;
    data['formatted_current_value'] = this.formattedCurrentValue;
    data['metal_content'] = this.metalContent;
    data['formatted_metal_content'] = this.formattedMetalContent;
    data['total_percentage_in_portfolio'] = this.totalPercentageInPortfolio;
    return data;
  }
}

class PortfolioChartData {
  DateTime? time;
  double? price;

  PortfolioChartData({required this.time, this.price});

  PortfolioChartData.fromJson(Map<String, dynamic> json) {
    time = DateTime.parse(json['posted_date'].toString());
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posted_date'] = this.time;
    data['price'] = this.price;
    return data;
  }
}
