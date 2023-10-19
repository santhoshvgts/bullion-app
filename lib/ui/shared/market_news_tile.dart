import 'package:bullion/core/models/market_news.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:flutter/material.dart';

class MarketNewsTile extends StatelessWidget {
  final MarketNews data;
  final bool showHeaderCard;

  MarketNewsTile(this.data, {this.showHeaderCard = false});

  MarketNewsTile.header(this.data, {this.showHeaderCard = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (data.openInNewWindow!) {
          launchAnUrl(data.externalLink!);

          locator<AnalyticsService>()
              .logScreenView(data.externalLink, className: "launch_url");
        } else {
          ApmexWebView.open(data.externalLink, title: "Market News");
          locator<AnalyticsService>()
              .logScreenView(data.externalLink, className: "in_app_browser");
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => WebViewDetailedPage(
          //       data.externalLink,
          //       "Market News",
          //     ),
          //   ),
          // );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: showHeaderCard ? MainTile(data) : NewsTile(data),
      ),
    );
  }
}

class MainTile extends StatelessWidget {
  const MainTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final MarketNews data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: AppColor.white),
          child: AspectRatio(
            aspectRatio: 1.62,
            child: Image.network(data.featureImage!, fit: BoxFit.contain),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 12)),
        Text(
          data.title!,
          textScaleFactor: 1,
          style: AppTextStyle.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        Padding(padding: EdgeInsets.only(top: 7)),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                data.source!,
                textScaleFactor: 1,
                style: AppTextStyle.labelMedium,
                maxLines: 1,
              ),
            ),
            Text(
              data.updatedAgo!,
              textScaleFactor: 1,
              style: AppTextStyle.labelMedium,
              maxLines: 1,
            )
          ],
        )
      ],
    );
  }
}

class NewsTile extends StatelessWidget {
  const NewsTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final MarketNews data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.white,
            ),
            child: AspectRatio(
              aspectRatio: 1.62,
              child: Image.network(data.featureImage!, fit: BoxFit.contain),
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                data.title!,
                textScaleFactor: 1,
                style: AppTextStyle.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(padding: EdgeInsets.only(top: 7)),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      data.source!,
                      textScaleFactor: 1,
                      style: AppTextStyle.labelMedium,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    data.updatedAgo!,
                    textScaleFactor: 1,
                    style: AppTextStyle.labelMedium,
                    maxLines: 1,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
