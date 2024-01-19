// ignore_for_file: library_private_types_in_public_api, must_be_immutable, prefer_generic_function_type_aliases

import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortDrawer extends StatelessWidget {
  Function(String) onSelect;
  ProductModel productModel;

  SortDrawer({
    Key? key,
    required this.onSelect,
    required this.productModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: AppColor.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacing.d10px(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HorizontalSpacing.d10px(),
                const Expanded(
                  child: Text(
                    'Sort By',
                    style: AppTextStyle.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => locator<DialogService>().dialogComplete(AlertResponse(status: true)),
                  icon: const Icon(
                    CupertinoIcons.clear,
                    size: 20,
                  ),
                )
              ],
            ),
            AppStyle.customDivider,
            VerticalSpacing.d5px(),
            Expanded(
              child: ListView.separated(
                itemCount: productModel.sortOptions?.length ?? 0,
                separatorBuilder: (context, index) {
                  return AppStyle.customDivider;
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => onSelect(productModel.sortOptions![index].value ?? ''),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        productModel.sortOptions![index].text ?? '',
                        style: AppTextStyle.titleMedium.copyWith(color: productModel.sortOptions![index].selected! ? AppColor.primary : AppColor.text),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
