import 'package:bullion/core/models/module/redirection.dart';
import 'package:bullion/services/api_request/page_request.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/analytics_service.dart';

class PageMiddlewareViewModel extends VGTSBaseViewModel {
  String? url;
  dynamic argument;

  Redirection? redirection;

  PageMiddlewareViewModel(this.url, this.argument);

  @override
  Future onInit() async {
    redirection = await request<Redirection>(PageRequest.getRoute(url: url));

    if (redirection?.requiredLogin == true) {
      navigationService.pushReplacementNamed(Routes.login, arguments: {'fromMain': false, 'redirectRoute': url});
      return;
    }

    if (redirection!.hasNativeRoute!) {
      navigationService.pushReplacementNamed(redirection!.targetUrl!);
      return;
    }

    navigationService.pop();
    if (redirection!.openInNewWindow!) {
      launchUrl(redirection!.targetUrl!);
      locator<AnalyticsService>().logScreenView(redirection!.targetUrl, className: "launch_url");
    } else {
      ApmexWebView.open(redirection!.targetUrl);
      locator<AnalyticsService>().logScreenView(redirection!.targetUrl, className: "in_app_browser");
    }
    return super.onInit();
  }
}
