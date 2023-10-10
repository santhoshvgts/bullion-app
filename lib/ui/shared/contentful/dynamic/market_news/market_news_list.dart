import 'package:bullion/core/models/market_news.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/header_card.dart';
import 'package:bullion/ui/shared/market_news_tile.dart';
import 'package:flutter/material.dart';

class MarketNewsList extends StatelessWidget {
  final List<dynamic>? dataList;
  final String? metalName;

  MarketNewsList(this.dataList, {this.metalName});

  List<MarketNews> get list =>
      dataList!.map((e) => MarketNews.fromJson(e)).toList();

  @override
  Widget build(BuildContext context) {
    if (list.isNotEmpty)
      return HeaderCard("Market News",
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length > 5 ? 5 : list.length,
                padding: EdgeInsets.only(top: 17, bottom: 10),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  return MarketNewsTile(list[index]);
                },
              ),
              TextButton(
                  key: Key("btnViewMore"),
                  onPressed: () {
                    String? metal = "";

                    if (metalName == null) {
                      if (list.length > 0) {
                        metal = list.first.tags;
                      }
                    } else {
                      metal = metalName;
                    }

                    if (['gold', 'silver', 'platinum', 'palladium']
                            .contains(metal?.toLowerCase()) !=
                        true) {
                      metal = "all";
                    }
                    locator<NavigationService>()
                        .pushNamed(Routes.marketNews + "/${metal}");
                  },
                  child: Text(
                    "View More",
                    textScaleFactor: 1,
                    style: AppTextStyle.titleSmall,
                  )),
              Padding(padding: EdgeInsets.only(bottom: 15)),
            ],
          ));
    else
      return Container();
  }
}
