import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/shared/search_card_section.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  final String? targetUrl;

  const SearchResultPage(this.targetUrl);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String? title = "";

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: SearchCardSection(
            rightPadding: 0,
            leftPadding: 0,
            placeholder: title,
          ),
          actions: const [
            CartButton.light(),
          ],
        ),
        // appBar: AppBar(
        //   backgroundColor: AppColor.white,
        //   centerTitle: false,
        //   automaticallyImplyLeading: false,
        //   titleSpacing: 0,
        //   elevation: 1,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       IconButton(
        //         icon: Icon(
        //           Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
        //           color: AppColor.text,
        //         ),
        //         onPressed: () => Navigator.pop(context),
        //       ),
        //       Expanded(
        //         child: InkWell(
        //           onTap: () {
        //             locator<NavigationService>().pushNamed(Routes.search);
        //           },
        //           child: Container(
        //               height: 35,
        //               padding: const EdgeInsets.only(left: 10.0),
        //               decoration: const BoxDecoration(
        //                   color: AppColor.secondaryBackground,
        //                   borderRadius: BorderRadius.all(Radius.circular(7.0))),
        //               child: Row(
        //                 children: [
        //                   Image.asset(
        //                     Images.search,
        //                     width: 15,
        //                   ),
        //                   HorizontalSpacing.d10px(),
        //                   Expanded(
        //                     child: Padding(
        //                       padding: const EdgeInsets.only(bottom: 2.0),
        //                       child: Text(
        //                         title ?? '',
        //                         style: AppTextStyle.bodyMedium,
        //                         textAlign: TextAlign.start,
        //                         textScaleFactor: 1,
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               )),
        //         ),
        //       ),
        //     ],
        //   ),
        //   actions: const [
        //     CartButton.light(),
        //   ],
        // ),
        body: ContentWrapper(
          widget.targetUrl,
          onPageFetched: (PageSettings? pageSetting) {
            if (pageSetting?.redirection != null) {
              print("REDIRECTION");
              if (pageSetting!.redirection!.hasNativeRoute!) {
                print("REDIRECTION ${pageSetting.redirection!.targetUrl}");
                locator<NavigationService>().pushReplacementNamed(
                  pageSetting.redirection!.targetUrl!,
                );
                return;
              }

              locator<NavigationService>().pop();
              if (pageSetting.redirection!.openInNewWindow!) {
                launchAnUrl(pageSetting.redirection!.targetUrl!);
              } else {
                ApmexWebView.open(pageSetting.redirection!.targetUrl);
              }
              return;
            }
            setState(() {
              title = pageSetting == null ? "" : pageSetting.searchTerm;
            });
          },
        ));
  }
}
