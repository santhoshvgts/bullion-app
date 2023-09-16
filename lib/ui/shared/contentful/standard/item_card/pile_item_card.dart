
import 'package:bullion/ui/shared/contentful/standard/standard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/standard_item.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:stacked/stacked.dart';

class PileItemCard extends ViewModelWidget<StandardViewModel> {

  final StandardItem item;

  PileItemCard(this.item,);

  @override
  Widget build(BuildContext context, StandardViewModel viewModel) {
    return InkWell(
      onTap: ()=> viewModel.onItemTap(item.targetUrl),
      child: Container(
        padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 3.0),
        decoration: BoxDecoration(
            color: viewModel.itemDisplaySettings.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: viewModel.itemDisplaySettings.textColor, width:0.8)
        ),
        child: Text(item.title!,textScaleFactor: 1, style: AppTextStyle.text.copyWith(color: viewModel.itemDisplaySettings.textColor),),
      ),
    );
  }

}
