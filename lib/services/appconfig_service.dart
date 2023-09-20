import 'dart:convert';
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
        ? AppStoreLinks.fromJson(json['AppStoreLinks'])
        : null;
    plaid = json['Plaid'] != null ? Plaid.fromJson(json['Plaid']) : null;
    webViewUrl = json['WebViewUrl'] != null
        ? WebViewUrl.fromJson(json['WebViewUrl'])
        : null;
    promoFAB = json['PromoFAB'] != null
        ? PromoFAB.fromJson(json['PromoFAB'])
        : null;
    appLinks = json['AppLinks'] != null
        ? AppLinks.fromJson(json['AppLinks'])
        : null;

    braintree = json['Braintree'] != null
        ? BraintreeObject.fromJson(json['Braintree'])
        : null;
    oneSignalID = json['OneSignalID'];

    if (json['KochavaKey'] != null) {
      kochavaInfo = Kochava.fromJson(json['KochavaKey']);
    }

    if (json['FreshChatKey'] != null) {
      freshChat = FreshChatModel.fromJson(json['FreshChatKey']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AppName'] = appName;
    data['V2BaseApiUrl'] = baseApiUrl;
    data['AppVersion'] = appVersion;
    data['AndroidAppVersion'] = androidAppVersion;
    data['IosAppVersion'] = iosAppVersion;
    data['AppVersionDate'] = appVersionDate;
    data['SiteUrl'] = siteUrl;
    data['Environment'] = environment;
    data['GoogleAPIKey'] = googleAPIKey;
    data['ShowDeleteAccountVersion'] = showDeleteButtonByVersion;
    if (appStoreLinks != null) {
      data['AppStoreLinks'] = appStoreLinks!.toJson();
    }
    if (appLinks != null) {
      data['AppLinks'] = appLinks!.toJson();
    }
    if (plaid != null) {
      data['Plaid'] = plaid!.toJson();
    }

    if (promoFAB != null) {
      data['PromoFAB'] = promoFAB!.toJson();
    }

    if (webViewUrl != null) {
      data['WebViewUrl'] = webViewUrl!.toJson();
    }
    if (braintree != null) {
      data['Braintree'] = braintree!.toJson();
    }
    data['OneSignalID'] = oneSignalID;

    if (kochavaInfo != null) {
      data['KochavaKey'] = kochavaInfo!.toJson();
    }

    if (freshChat != null) {
      data['FreshChatKey'] = freshChat!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['target_url'] = targetUrl;
    data['bg_color'] = bgColor;
    data['image_url'] = imageUrl;
    return data;
  }
}

class AppStoreLinks {
  AppStoreLink? androidStore;
  AppStoreLink? iosStore;

  AppStoreLinks({this.androidStore, this.iosStore});

  AppStoreLinks.fromJson(Map<String, dynamic> json) {
    androidStore = json['AndroidStore'] != null
        ? AppStoreLink.fromJson(json['AndroidStore'])
        : null;
    iosStore = json['IosStore'] != null
        ? AppStoreLink.fromJson(json['IosStore'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (androidStore != null) {
      data['AndroidStore'] = androidStore!.toJson();
    }
    if (iosStore != null) {
      data['IosStore'] = iosStore!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Url'] = url;
    data['AppID'] = appID;
    data['Version'] = version;
    data['ReviewUrl'] = reviewUrl;
    data['ForceUpdate'] = forceUpdate;
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
    sellToUs = json['SellToUs'] != null ? SellToUs.fromJson(json['SellToUs']) : null;
    autoInvest = json['AutoInvest'] != null ? AutoInvest.fromJson(json['AutoInvest']) : null;
    checkoutTermCancelPolicy = json['CheckoutTermCancelPolicy'];
    apmexClubStatus = json['ApmexClubStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['WebUrl'] = webUrl;
    data['MyAccount'] = myAccountUrl;
    data['ShopDeal'] = shopDealLink;
    data['PorfolioTool'] = portfolioToolUrl;
    data['OrderHistory'] = orderHistoryUrl;
    data['WhereIsMyOrder'] = whereIsMyOrderUrl;
    data['ShopNow'] = shopNowUrl;
    data['GoldLink'] = goldProductUrl;
    data['SliverLink'] = sliverProductUrl;
    data['PlatinumLink'] = platinumProductUrl;
    data['PalladiumLink'] = palladiumProductUrl;

    data['SupportUrl'] = supportUrl;
    data['AppleAppStoreUrl'] = appleAppStoreUrl;
    data['GooglePlayStoreUrl'] = googlePlayStoreUrl;
    data['Privacy'] = privacy;
    data['UserAgreement'] = userAgreement;
    data['TollFree'] = tollFree;
    data['LocalNumber'] = localNumber;
    data['FaxNo'] = faxNo;
    if (sellToUs != null) {
      data['SellToUs'] = sellToUs!.toJson();
    }
    if (autoInvest != null) {
      data['AutoInvest'] = autoInvest!.toJson();
    }
    data['HoursOfOperation'] = hoursOfOperation;
    data['FAQUrl'] = fAQUrl;
    data['FAQUrl'] = fAQUrl;
    data['ApmexClubStatus'] = apmexClubStatus;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Production'] = production;
    data['MerchantId'] = merchantId;
    data['PublicKey'] = publicKey;
    data['PrivateKey'] = privateKey;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Blacklist'] = blacklist;
    data['Whitelist'] = whitelist;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AndroidGUID'] = AndroidGUID;
    data['IosGUID'] = IosGUID;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SellToUsUrl'] = sellToUsUrl;
    data['SellToUsUrlImage'] = sellToUsUrlImage;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AutoInvestUrl'] = autoInvestUrl;
    return data;
  }
}
