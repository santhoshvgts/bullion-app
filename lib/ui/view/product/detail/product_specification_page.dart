import 'package:bullion/core/models/module/product_detail/specifications.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter/material.dart';

class ProductSpecificationPage extends StatelessWidget {
  final List<Specifications>? spec;

  ProductSpecificationPage(this.spec);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBackground,
      appBar: AppBar(
        title: Text(
          "Product Specification",
          style: AppTextStyle.titleLarge,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        color: AppColor.white,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.all(15.0),
          itemCount: spec!.length,
          separatorBuilder: (BuildContext context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: AppStyle.customDivider,
          ),
          itemBuilder: (BuildContext context, index) {
            return SpecificationItem(spec![index]);
          },
        ),
      ),
    );
  }
}

class SpecificationItem extends StatelessWidget {
  Specifications data;

  SpecificationItem(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            data.key!,
            textScaleFactor: 1,
            style: AppTextStyle.bodyMedium,
          ),
          if (data.keyHelpText!.isNotEmpty)
            InkWell(
              onTap: () {
                // TODO - Volume Discount
                // locator<DialogService>().showBottomSheet(title: data.key, child: VolumeInfoBottomSheet(data.keyHelpText));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                ),
              ),
            ),
          Expanded(
              child: Text(
            data.value!,
            textScaleFactor: 1,
            style:
                AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          )),
        ],
      ),
    );
  }
}
