import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/chart/chart_data.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:flutter/material.dart';

class SpotPrice extends BaseModel {
  String? metalName;
  String? title;
  double? bid;
  double? ask;
  double? change;
  double? changePct;
  double? last;
  int? metalId;
  int? orderBy;
  String? targetUrl;
  String? formattedBid;
  String? formattedAsk;
  String? formattedChange;
  String? lastUpdated;
  String? formattedLastUpdated;
  String? formattedPerGramAsk;
  String? formattedPerGramChange;
  String? formattedPerKiloAsk;
  String? formattedPerKiloChange;
  List<ChartData>? chartData;

  bool get canChangeWatchList {
    return [1, 2, 3, 4].contains(metalId) == false && metalName != "Portfolio";
  }

  Color get color => AppColor.secondaryMetalColor(metalName ?? '');
  Color get areaColor => AppColor.metalColor(metalName ?? '').withOpacity(0.2);

  SpotPrice({
    this.metalName,
    this.title,
    this.bid,
    this.ask,
    this.change,
    this.changePct,
    this.last,
    this.metalId,
    this.orderBy,
    this.formattedBid,
    this.formattedAsk,
    this.formattedChange,
    this.lastUpdated,
    this.formattedLastUpdated,
    this.formattedPerGramAsk,
    this.formattedPerGramChange,
    this.formattedPerKiloAsk,
    this.formattedPerKiloChange,
    this.chartData,
  });

  @override
  SpotPrice fromJson(json) => SpotPrice.fromJson(json);

  SpotPrice.fromJson(Map<String, dynamic> json) {
    metalName = json['metal_name'];
    title = json['title'];
    bid = double.parse(json['bid'].toString());
    ask = double.parse(json['ask'].toString());
    change = double.parse(json['change'].toString());
    changePct = double.parse(json['change_pct'].toString());
    last = double.parse(json['last'].toString());
    metalId = json['metal_id'];
    targetUrl = json['target_url'];
    orderBy = json['order_by'];
    formattedBid = json['formatted_bid'];
    formattedAsk = json['formatted_ask'];
    formattedChange = json['formatted_change'];
    lastUpdated = json['last_updated'];
    formattedLastUpdated = json['formatted_last_updated'];
    formattedPerGramAsk = json['formatted_per_gram_ask'];
    formattedPerGramChange = json['formatted_per_gram_change'];
    formattedPerKiloAsk = json['formatted_per_kilo_ask'];
    formattedPerKiloChange = json['formatted_per_kilo_change'];
    if (json['chart_data'] != null) {
      chartData = <ChartData>[];
      json['chart_data'].forEach((v) {
        chartData!.add(new ChartData.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['metal_name'] = this.metalName;
    data['title'] = this.title;
    data['bid'] = this.bid;
    data['ask'] = this.ask;
    data['change'] = this.change;
    data['change_pct'] = this.changePct;
    data['last'] = this.last;
    data['metal_id'] = this.metalId;
    data['target_url'] = this.targetUrl;
    data['order_by'] = this.orderBy;
    data['formatted_bid'] = this.formattedBid;
    data['formatted_ask'] = this.formattedAsk;
    data['formatted_change'] = this.formattedChange;
    data['last_updated'] = this.lastUpdated;
    data['formatted_last_updated'] = this.formattedLastUpdated;
    data['formatted_per_gram_ask'] = this.formattedPerGramAsk;
    data['formatted_per_gram_change'] = this.formattedPerGramChange;
    data['formatted_per_kilo_ask'] = this.formattedPerKiloAsk;
    data['formatted_per_kilo_change'] = this.formattedPerKiloChange;
    if (this.chartData != null) {
      data['chart_data'] = this.chartData!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotPrice &&
          runtimeType == other.runtimeType &&
          metalName == other.metalName &&
          metalId == other.metalId;

  @override
  int get hashCode => metalName.hashCode ^ metalId.hashCode;
}
