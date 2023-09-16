
import 'package:bullion/ui/shared/contentful/module/module_ui_container.dart';
import 'package:bullion/ui/shared/contentful/standard/item_card/pile_item_card.dart';
import 'package:bullion/ui/shared/contentful/standard/item_card/standard_item_card.dart';
import 'package:bullion/ui/shared/contentful/standard/standard_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/constants/alignment.dart';
import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/item_display_settings.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/fontsize.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

import 'item_card/cell_item_card.dart';

class StandardModule extends VGTSBuilderWidget<StandardViewModel> {

  final ModuleSettings? settings;

  StandardModule(this.settings);

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(StandardViewModel vm) {
    vm.init(this.settings!);
  }
  @override
  StandardViewModel viewModelBuilder(BuildContext context) => StandardViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, StandardViewModel viewModel, Widget? child) {
    return ModuleUIContainer(
      settings,
      hideHeadSection: false,
      children: [

        Container(
            margin: EdgeInsets.only(top: viewModel.settings.hasHeaderSection ? 10 : 0),
            child: _ItemCard()
        ),

        if(viewModel.itemDisplaySettings.collpasable && !viewModel.isCollPaSable)
          _CollPaSableButton()
        else
          if(viewModel.isCollPaSable)
            _ShowLess()

      ],
    );
  }

}

class _ItemCard extends ViewModelWidget<StandardViewModel> {

  @override
  Widget build(BuildContext context, StandardViewModel viewModel) {

    switch(viewModel.itemDisplaySettings.displayType){

    // Pill Display Type
      case DisplayType.pill:
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Wrap(
            spacing: 7,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: viewModel.items!.map((item) {
              return PileItemCard(item);
            }).toList(),
          ),
        );

    // Cell Display Type
      case DisplayType.cell:
        return  Container(
          margin: viewModel.settings.displaySettings!.fullBleed ? null : const EdgeInsets.only(left: 10.0,right: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: AppColor.white,
          child: _WrapItemList(
            wrap: viewModel.itemDisplaySettings.wrapItems,
            runSpacing: 0,
            spacing: 0,
            itemDisplaySettings: viewModel.itemDisplaySettings,
            children: viewModel.items!.asMap().map((index, item){
              return MapEntry(index, CellItemCard(item,index,viewModel.items!.length));
            }).values.toList(),
          ),
        );

      case DisplayType.promoText:
        return _WrapItemList(
          wrap: viewModel.itemDisplaySettings.wrapItems,
          runSpacing: 0,
          spacing: 0,
          itemDisplaySettings: viewModel.itemDisplaySettings,
          children: viewModel.items!.asMap().map((index, item){
            return MapEntry(index, InkWell(
              onTap: ()=> viewModel.onItemTap(item.targetUrl),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 2),
                child: Text(item.content!,textScaleFactor: 1,
                    style: AppTextStyle.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSize.bodyContentByValue(viewModel.itemDisplaySettings.titleStyle),
                        color: viewModel.itemDisplaySettings.textColor),textAlign:UIAlignment.textAlign(viewModel.itemDisplaySettings.contentAlignment)),
              ),
            ));
          }).values.toList(),
        );

    // Standard Display Type
      default:
        return _WrapItemList(
          wrap: viewModel.itemDisplaySettings.wrapItems,
          runSpacing: viewModel.runSpacing,
          spacing: viewModel.spacing,
          itemDisplaySettings: viewModel.itemDisplaySettings,
          children: viewModel.items!.asMap().map((index, item){
            return MapEntry(index, Container(
              width: viewModel.itemWidth(context),
              child: StandardItemCard(item, itemDisplaySettings: viewModel.itemDisplaySettings,),
            ));
          }).values.toList(),
        );
    }
  }

}

class _WrapItemList extends StatelessWidget {

  final bool wrap;
  final Axis direction;
  final double runSpacing;
  final double spacing;
  final List<Widget> children;
  final ItemDisplaySettings? itemDisplaySettings;

  _WrapItemList({this.wrap = false, this.direction = Axis.horizontal, this.runSpacing = 0.0, this.itemDisplaySettings, this.spacing = 0.0, this.children = const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    if (wrap) {
      return SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: runSpacing,),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: _buildWrapItems(itemDisplaySettings?.itemMainAxisAlignment),)
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: direction,
        primary: false,
        controller: new ScrollController(keepScrollOffset: false),
        padding: itemDisplaySettings!.fullBleed ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: runSpacing),
        child: IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children.map((e) => Padding(
                padding: EdgeInsets.only(right: spacing),
                child: e,
              )).toList()
          ),
        ),

      );
    }

  }

  List<Widget> _buildWrapItems(MainAxisAlignment? itemMainAxisAlignment){

    if (itemDisplaySettings!.gridCols <= 1){
      return children.expand((e) => [e, SizedBox(height: children.length > 1 ? spacing : 0,)]).toList();
    }


    List<Widget> items = [];
    List<Widget> childItem = children;

    while(childItem.length > 0){
      List<Widget> tuple = childItem.take(itemDisplaySettings!.gridCols).toList();

      tuple.forEach((element) {
        if (childItem.length > 0) childItem.removeAt(0);
      });

      Widget item = IntrinsicHeight(
        child: Row(
          mainAxisAlignment: itemMainAxisAlignment ?? MainAxisAlignment.spaceBetween,
          children: tuple.map((e) => e).toList(),
        ),
      );

      items.add(item);
    }

    return items.expand((element) => [
      element,
      SizedBox(
        height: spacing,
      )
    ]).toList();
  }

}


class _CollPaSableButton extends ViewModelWidget<StandardViewModel> {
  @override
  Widget build(BuildContext context, StandardViewModel viewModel) {

    if (viewModel.moreCategoriesLength <= 0){
      return Container();
    }

    return  TextButton(onPressed:()=>viewModel.onChange(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Show ${viewModel.moreCategoriesLength} more Categories",
              style: AppTextStyle.text.copyWith(color: const Color(0xff008fbe), fontWeight: FontWeight.w600),textScaleFactor: 1,),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(Icons.arrow_drop_down_sharp,size: 35,color: Color(0xff008fbe)),
            )
          ],
        )
    );
  }
}

class _ShowLess extends ViewModelWidget<StandardViewModel> {
  @override
  Widget build(BuildContext context, StandardViewModel viewModel) {
    return TextButton(
        onPressed:() => viewModel.onChange(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Show Less", style: AppTextStyle.text.copyWith(color: const Color(0xff008fbe), fontWeight: FontWeight.w600),textScaleFactor: 1,),
            const Padding(
              padding: EdgeInsets.only(top:5.0),
              child: Icon(Icons.arrow_drop_up,size: 35,color: Color(0xff008fbe)),
            )
        ],
      )
    );
  }

}
