import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/search_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';

class TrendingSection extends StatelessWidget {

  final ModuleSettings? settings;

  TrendingSection(this.settings);

  List<SearchItem> get list => settings!.dynamicItemData!.map((e) => SearchItem.fromJson(e)).toList();

  @override
  Widget build(BuildContext context,) {

   return Container(
     alignment: Alignment.centerLeft,
     padding: EdgeInsets.all(15.0),
     margin: EdgeInsets.only(top: 10,),
     color: AppColor.white,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [

         Text(settings!.title ?? "Top Searches",
             textScaleFactor: 1,
             textAlign:TextAlign.start,
             style: AppTextStyle.title
         ),

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

  _ItemCard(this._item,);

  @override
  Widget build(BuildContext context,) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        locator<NavigationService>().pushAndPopUntil(_item.targetUrl!, removeRouteName: Routes.dashboard);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 3),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: AppColor.text, width:0.8)
        ),
        child: Text(_item.name!,textScaleFactor: 1, style: AppTextStyle.text.copyWith(fontSize: 13),),
      ),
    );
  }

}