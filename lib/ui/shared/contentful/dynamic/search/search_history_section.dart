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

class SearchHistorySection extends StatelessWidget {
  final ModuleSettings? settings;

  SearchHistorySection(this.settings);

  List<SearchItem> get list =>
      settings!.dynamicItemData!.map((e) => SearchItem.fromJson(e)).toList();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(15),
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            settings!.title ?? "Recent Searches",
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: AppTextStyle.titleMedium,
          ),
          VerticalSpacing.d10px(),

          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _ItemCard(list[index]);
            },
            separatorBuilder: (context, index) {
              return AppStyle.customDivider;
            },
            itemCount: list.length
          )

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
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      color: AppColor.white,
      child: InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
            locator<NavigationService>().pushAndPopUntil(_item.targetUrl!,
                removeRouteName: Routes.dashboard);
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _item.name!,
                  style: AppTextStyle.bodyMedium
                      .copyWith(fontSize: 16, fontWeight: FontWeight.normal),
                  textScaleFactor: 1,
                ),
              ),
              const Icon(CupertinoIcons.arrow_up_right)
            ],
          )),
    );
  }
}
