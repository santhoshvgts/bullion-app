import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:bullion/services/shared/device_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApmexWebView {
  static open(String? url, {String? title = "BULLION"}) {
    locator<NavigationService>().push(MaterialPageRoute(
        builder: (context) => ApmexWebViewPage(
              url,
              title: title,
            )));
  }
}

class ApmexWebViewPage extends StatefulWidget {
  final String? url;
  final String? title;

  ApmexWebViewPage(this.url, {this.title = "BULLION"});

  @override
  _ApmexWebViewPageState createState() => _ApmexWebViewPageState();
}

class _ApmexWebViewPageState extends State<ApmexWebViewPage> {
  bool isLoading = true;
  Map<String, String?>? headers;

  bool showWebView = false;

  int progress = 0;
  double opacity = 0.0;

  late WebViewController controller;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    headers = await ApiBaseService().getWebViewHeader();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(locator<DeviceService>().getWebViewUserAgent())
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              opacity = 1.0;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigationDelegate) {
            print("URL ${navigationDelegate.url.toLowerCase()}");
            print("Widget URL ${widget.url?.toLowerCase()}");

            if (navigationDelegate.url.toLowerCase() ==
                widget.url?.toLowerCase()) {
              return NavigationDecision.navigate;
            }

            print("isMainFrame ${navigationDelegate.isMainFrame}");

            if (!navigationDelegate.isMainFrame) {
              return NavigationDecision.prevent;
            }

            List<String> blacklistUrl =
                locator<AppConfigService>().config?.webViewUrl?.blacklist ?? [];
            List<String> whitelistUrl =
                locator<AppConfigService>().config?.webViewUrl?.whitelist ?? [];

            print(blacklistUrl.toString());
            print(whitelistUrl.toString());

            String? blackList = blacklistUrl.singleWhereOrNull(
                (element) => navigationDelegate.url.startsWith(element));

            if (blackList != null) {
              return NavigationDecision.prevent;
            }

            String? whitelist = whitelistUrl.singleWhereOrNull(
                (element) => navigationDelegate.url.startsWith(element));

            if (whitelist != null) {
              Uri uri = Uri.parse(navigationDelegate.url);
              locator<NavigationService>().pushNamed(
                uri.path + (uri.hasQuery ? "?${uri.query}" : ""),
              );
            } else {
              launchUrl(navigationDelegate.url);
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url!));

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? '',
            textScaleFactor: 1,
            style: AppTextStyle.titleLarge,
          ),
        ),
        body: Column(
          children: [
            progress < 100
                ? LinearProgressIndicator(
                    value: progress / 100,
                    valueColor: const AlwaysStoppedAnimation(AppColor.primary),
                  )
                : Container(),
            Flexible(
                child: headers == null
                    ? const Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColor.primary),
                      ))
                    : Opacity(
                        opacity: opacity,
                        child: WebViewWidget(
                          controller: controller,
                        ),
                      )),
          ],
        ));
  }
}
