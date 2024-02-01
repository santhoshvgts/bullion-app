import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/search_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendingSection extends StatelessWidget {
  final ModuleSettings? settings;

  TrendingSection(this.settings);

  List<SearchItem> get list =>
      settings!.dynamicItemData!.map((e) => SearchItem.fromJson(e)).toList();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(15.0),
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(settings!.title ?? "Trending Searches",
              
              textAlign: TextAlign.start,
              style: AppTextStyle.titleMedium),
          VerticalSpacing.d15px(),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: list.map((item) {
              return _ItemCard(item);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final SearchItem _item;

  _ItemCard(
    this._item,
  );

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        locator<NavigationService>().pushAndPopUntil(_item.targetUrl!,
            removeRouteName: Routes.dashboard);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 15.0, bottom: 5.0, top: 5),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: AppColor.text, width: 0.8)),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [

            const Icon(Icons.trending_up_sharp, color: AppColor.text,),

            HorizontalSpacing.d5px(),

            Text(
              _item.name!,
              
              style: AppTextStyle.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
