import 'package:bullion/ui/shared/contentful/standard/standard_text_style.dart';
import 'package:bullion/ui/shared/contentful/standard/standard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/standard_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:stacked/stacked.dart';

class CellItemCard extends ViewModelWidget<StandardViewModel> {
  final StandardItem item;
  final index;
  final itemLength;

  CellItemCard(this.item, this.index, this.itemLength);

  @override
  Widget build(BuildContext context, StandardViewModel viewModel) {
    return InkWell(
      onTap: () => viewModel.onItemTap(item.targetUrl),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  item.imageUrl!,
                  width: 50,
                ),
                HorizontalSpacing.custom(value: 15.0),
                Expanded(
                  child: Text(
                    item.title!,
                    textScaleFactor: 1,
                    style: StandardTextStyle.subtitle("medium"),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.chipShadowColor,
                  size: 15,
                )
              ],
            ),
            Container(
              height: 1,
              margin: EdgeInsets.only(left: 63),
              child: AppStyle.customDivider,
            )
          ],
        ),
      ),
    );
  }
}
