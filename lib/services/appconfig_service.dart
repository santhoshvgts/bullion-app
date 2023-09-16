import 'dart:convert';
import 'dart:io';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/helper/utils.dart';
import 'package:flutter/material.dart';

class AppConfigService {
  AppConfig? _appConfig;

  AppConfig? get config {
    return _appConfig;
  }

  setConfig(String value) {
    if (value.isNotEmpty == true)
      _appConfig = AppConfig.fromJson(jsonDecode(value));
  }
}

class AppConfig {
  String? appName;
  String? baseApiUrl;
  String? appVersion;
  String? androidAppVersion;
  String? iosAppVersion;
  String? appVersionDate;
  String? siteUrl;
  String? environment;
  AppStoreLinks? appStoreLinks;
  AppLinks? appLinks;
  Plaid? plaid;
  WebViewUrl? webViewUrl;
  BraintreeObject? braintree;
  String? oneSignalID;
  String? googleAPIKey;
  Kochava? kochavaInfo;
  FreshChatModel? freshChat;
  PromoFAB? promoFAB;
  String? showDeleteButtonByVersion;

  AppConfig({
    this.appName,
    this.baseApiUrl,
    this.appVersion,
    this.androidAppVersion,
    this.iosAppVersion,
    this.appVersionDate,
    this.siteUrl,
    this.environment,
    this.appStoreLinks,
    this.appLinks,
    this.oneSignalID,
    this.kochavaInfo,
    this.freshChat,
    this.showDeleteButtonByVersion,
  });

  AppConfig.fromJson(Map<String, dynamic> json) {
    appName = json['AppName'];
    baseApiUrl = json['V2BaseApiUrl'];
    appVersion = json['AppVersion'];
    androidAppVersion = json['AndroidAppVersion'];
    iosAppVersion = json['IosAppVersion'];
    appVersionDate = json['AppVersionDate'];
    siteUrl = json['SiteUrl'];
    environment = json['Environment'];
    googleAPIKey = json['GoogleAPIKey'];
    showDeleteButtonByVersion = json['ShowDeleteAccountVersion'];
    appStoreLinks = json['AppStoreLinks'] != null
        ? new AppStoreLinks.fromJson(json['AppStoreLinks'])
        : null;
    plaid = json['Plaid'] != null ? new Plaid.fromJson(json['Plaid']) : null;
    webViewUrl = json['WebViewUrl'] != null
        ? new WebViewUrl.fromJson(json['WebViewUrl'])
        : null;
    promoFAB = json['PromoFAB'] != null
        ? new PromoFAB.fromJson(json['PromoFAB'])
        : null;
    appLinks = json['AppLinks'] != null
        ? new AppLinks.fromJson(json['AppLinks'])
        : null;

    braintree = json['Braintree'] != null
        ? new BraintreeObject.fromJson(json['Braintree'])
        : null;
    oneSignalID = json['OneSignalID'];

    if (json['KochavaKey'] != null) {
      kochavaInfo = new Kochava.fromJson(json['KochavaKey']);
    }

    if (json['FreshChatKey'] != null) {
      freshChat = FreshChatModel.fromJson(json['FreshChatKey']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppName'] = this.appName;
    data['V2BaseApiUrl'] = this.baseApiUrl;
    data['AppVersion'] = this.appVersion;
    data['AndroidAppVersion'] = this.androidAppVersion;
    data['IosAppVersion'] = this.iosAppVersion;
    data['AppVersionDate'] = this.appVersionDate;
    data['SiteUrl'] = this.siteUrl;
    data['Environment'] = this.environment;
    data['GoogleAPIKey'] = this.googleAPIKey;
    data['ShowDeleteAccountVersion'] = this.showDeleteButtonByVersion;
    if (this.appStoreLinks != null) {
      data['AppStoreLinks'] = this.appStoreLinks!.toJson();
    }
    if (this.appLinks != null) {
      data['AppLinks'] = this.appLinks!.toJson();
    }
    if (this.plaid != null) {
      data['Plaid'] = this.plaid!.toJson();
    }

    if (this.promoFAB != null) {
      data['PromoFAB'] = this.promoFAB!.toJson();
    }

    if (this.webViewUrl != null) {
      data['WebViewUrl'] = this.webViewUrl!.toJson();
    }
    if (this.braintree != null) {
      data['Braintree'] = this.braintree!.toJson();
    }
    data['OneSignalID'] = this.oneSignalID;

    if (this.kochavaInfo != null) {
      data['KochavaKey'] = this.kochavaInfo!.toJson();
    }

    if (this.freshChat != null) {
      data['FreshChatKey'] = this.freshChat!.toJson();
    }
    return data;
  }
}

class PromoFAB {
  String? title;
  String? targetUrl;
  String? bgColor;
  String? imageUrl;

  Color get color => getColorFromString(bgColor, fallbackColor: AppColor.primary);

  PromoFAB({this.title, this.targetUrl, this.bgColor, this.imageUrl});

  PromoFAB.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    targetUrl = json['target_url'];
    bgColor = json['bg_color'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['target_url'] = this.targetUrl;
    data['bg_color'] = this.bgColor;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class AppStoreLinks {
  AppStoreLink? androidStore;
  AppStoreLink? iosStore;

  AppStoreLinks({this.androidStore, this.iosStore});

  AppStoreLinks.fromJson(Map<String, dynamic> json) {
    androidStore = json['AndroidStore'] != null
        ? new AppStoreLink.fromJson(json['AndroidStore'])
        : null;
    iosStore = json['IosStore'] != null
        ? new AppStoreLink.fromJson(json['IosStore'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.androidStore != null) {
      data['AndroidStore'] = this.androidStore!.toJson();
    }
    if (this.iosStore != null) {
      data['IosStore'] = this.iosStore!.toJson();
    }
    return data;
  }
}

class AppStoreLink {
  String? url;
  String? appID;
  String? version;
  String? reviewUrl;
  bool? forceUpdate;

  AppStoreLink(
      {this.url, this.appID, this.version, this.reviewUrl, this.forceUpdate});

  AppStoreLink.fromJson(Map<String, dynamic> json) {
    url = json['Url'];
    appID = json['AppID'];
    version = json['Version'];
    reviewUrl = json['ReviewUrl'];
    forceUpdate = json['ForceUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Url'] = this.url;
    data['AppID'] = this.appID;
    data['Version'] = this.version;
    data['ReviewUrl'] = this.reviewUrl;
    data['ForceUpdate'] = this.forceUpdate;
    return data;
  }
}

class AppLinks {
  String? webUrl;
  String? myAccountUrl;
  String? shopDealLink;
  String? portfolioToolUrl;
  String? orderHistoryUrl;
  String? whereIsMyOrderUrl;
  String? shopNowUrl;
  String? goldProductUrl;
  String? sliverProductUrl;
  String? platinumProductUrl;
  String? palladiumProductUrl;

  String? supportEmail;
  String? supportUrl;
  String? forgotPasswordUrl;
  String? appleAppStoreUrl;
  String? googlePlayStoreUrl;
  String? privacy;
  String? userAgreement;
  String? tollFree;
  String? localNumber;
  String? faxNo;
  String? hoursOfOperation;
  String? fAQUrl;
  SellToUs? sellToUs;
  AutoInvest? autoInvest;
  String? checkoutTermCancelPolicy;
  String? apmexClubStatus;

  AppLinks(
      {this.supportEmail,
      this.supportUrl,
      this.webUrl,
      this.forgotPasswordUrl,
      this.appleAppStoreUrl,
      this.googlePlayStoreUrl,
      this.privacy,
      this.userAgreement,
      this.tollFree,
      this.localNumber,
      this.faxNo,
      this.hoursOfOperation,
      this.fAQUrl,
      this.sellToUs});

  AppLinks.fromJson(Map<String, dynamic> json) {
    webUrl = json['WebUrl'];
    myAccountUrl = json['MyAccount'];
    shopDealLink = json['ShopDeal'];
    portfolioToolUrl = json['PorfolioTool'];
    orderHistoryUrl = json['OrderHistory'];
    whereIsMyOrderUrl = json['WhereIsMyOrder'];
    shopNowUrl = json['ShopNow'];
    goldProductUrl = json['GoldLink'];
    sliverProductUrl = json['SliverLink'];
    platinumProductUrl = json['PlatinumLink'];
    palladiumProductUrl = json['PalladiumLink'];

    supportEmail = json['SupportEmail'];
    supportUrl = json['SupportUrl'];
    appleAppStoreUrl = json['AppleAppStoreUrl'];
    googlePlayStoreUrl = json['GooglePlayStoreUrl'];
    privacy = json['Privacy'];
    userAgreement = json['UserAgreement'];
    tollFree = json['TollFree'];
    localNumber = json['LocalNumber'];
    faxNo = json['FaxNo'];
    forgotPasswordUrl = json['ForgotPasswordUrl'];
    hoursOfOperation = json['HoursOfOperation'];
    fAQUrl = json['FAQUrl'];
    sellToUs = json['SellToUs'] != null ? new SellToUs.fromJson(json['SellToUs']) : null;
    autoInvest = json['AutoInvest'] != null ? new AutoInvest.fromJson(json['AutoInvest']) : null;
    checkoutTermCancelPolicy = json['CheckoutTermCancelPolicy'];
    apmexClubStatus = json['ApmexClubStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WebUrl'] = this.webUrl;
    data['MyAccount'] = this.myAccountUrl;
    data['ShopDeal'] = this.shopDealLink;
    data['PorfolioTool'] = this.portfolioToolUrl;
    data['OrderHistory'] = this.orderHistoryUrl;
    data['WhereIsMyOrder'] = this.whereIsMyOrderUrl;
    data['ShopNow'] = this.shopNowUrl;
    data['GoldLink'] = this.goldProductUrl;
    data['SliverLink'] = this.sliverProductUrl;
    data['PlatinumLink'] = this.platinumProductUrl;
    data['PalladiumLink'] = this.palladiumProductUrl;

    data['SupportUrl'] = this.supportUrl;
    data['AppleAppStoreUrl'] = this.appleAppStoreUrl;
    data['GooglePlayStoreUrl'] = this.googlePlayStoreUrl;
    data['Privacy'] = this.privacy;
    data['UserAgreement'] = this.userAgreement;
    data['TollFree'] = this.tollFree;
    data['LocalNumber'] = this.localNumber;
    data['FaxNo'] = this.faxNo;
    if (this.sellToUs != null) {
      data['SellToUs'] = this.sellToUs!.toJson();
    }
    if (this.autoInvest != null) {
      data['AutoInvest'] = this.autoInvest!.toJson();
    }
    data['HoursOfOperation'] = this.hoursOfOperation;
    data['FAQUrl'] = this.fAQUrl;
    data['FAQUrl'] = this.fAQUrl;
    data['ApmexClubStatus'] = this.apmexClubStatus;
    return data;
  }
}

class Plaid {
  String? baseUrl;
  bool? production;
  String? environment;
  String? merchantId;
  String? publicKey;
  String? privateKey;
  String? webHook;

  Plaid.fromJson(dynamic json) {
    baseUrl = json["BaseUrl"];
    production = json["Production"];
    environment = json["Environment"];
    merchantId = json["MerchantId"];
    publicKey = json["PublicKey"];
    privateKey = json["PrivateKey"];
    webHook = json["WebHook"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["BaseUrl"] = baseUrl;
    map["Production"] = production;
    map["Environment"] = environment;
    map["MerchantId"] = merchantId;
    map["PublicKey"] = publicKey;
    map["PrivateKey"] = privateKey;
    map["WebHook"] = webHook;
    return map;
  }
}

class BraintreeObject {
  bool? production;
  String? merchantId;
  String? publicKey;
  String? privateKey;

  BraintreeObject(
      {this.production, this.merchantId, this.publicKey, this.privateKey});

  BraintreeObject.fromJson(Map<String, dynamic> json) {
    production = json['Production'];
    merchantId = json['MerchantId'];
    publicKey = json['PublicKey'];
    privateKey = json['PrivateKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Production'] = this.production;
    data['MerchantId'] = this.merchantId;
    data['PublicKey'] = this.publicKey;
    data['PrivateKey'] = this.privateKey;
    return data;
  }
}

class WebViewUrl {
  List<String>? blacklist;
  List<String>? whitelist;

  WebViewUrl({this.blacklist, this.whitelist});

  WebViewUrl.fromJson(Map<String, dynamic> json) {
    blacklist = json['Blacklist'].cast<String>();
    whitelist = json['Whitelist'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Blacklist'] = this.blacklist;
    data['Whitelist'] = this.whitelist;
    return data;
  }
}

class Kochava {
  late String AndroidGUID;
  late String IosGUID;

  Kochava.fromJson(Map<String, dynamic> json) {
    AndroidGUID = json['AndroidGUID'];
    IosGUID = json['IosGUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AndroidGUID'] = this.AndroidGUID;
    data['IosGUID'] = this.IosGUID;
    return data;
  }
}

class FreshChatModel {
  FreshChatModel({
    this.appId,
    this.appKey,
    this.domain,
  });

  final String? appId;
  final String? appKey;
  final String? domain;

  factory FreshChatModel.fromJson(Map<String, dynamic> json) => FreshChatModel(
        appId: json["AppID"],
        appKey: json["AppKey"],
        domain: json["Domain"],
      );

  Map<String, dynamic> toJson() => {
        "AppID": appId,
        "AppKey": appKey,
        "Domain": domain,
      };
}

class SellToUs {
  String? sellToUsUrl;
  String? sellToUsUrlImage;

  SellToUs({this.sellToUsUrl, this.sellToUsUrlImage});

  SellToUs.fromJson(Map<String, dynamic> json) {
    sellToUsUrl = json['SellToUsUrl'];
    sellToUsUrlImage = json['SellToUsUrlImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SellToUsUrl'] = this.sellToUsUrl;
    data['SellToUsUrlImage'] = this.sellToUsUrlImage;
    return data;
  }
}

class AutoInvest {
  String? autoInvestUrl;

  AutoInvest({this.autoInvestUrl});

  AutoInvest.fromJson(Map<String, dynamic> json) {
    autoInvestUrl = json['AutoInvestUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AutoInvestUrl'] = this.autoInvestUrl;
    return data;
  }
}
