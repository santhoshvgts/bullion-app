import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchCardSection extends PreferredSize {
  double? height;
  double? leftPadding;
  double? rightPadding;
  String? placeholder;

  SearchCardSection({
    super.key,
    this.height,
    this.rightPadding,
    this.leftPadding,
    this.placeholder,
  }) : super(
          preferredSize: Size(double.infinity, height ?? 35),
          child: InkWell(
            onTap: () {
              locator<NavigationService>().pushNamed(Routes.search);
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: height ?? 35,
              margin: EdgeInsets.only(
                left: leftPadding ?? 15,
                right: rightPadding ?? 15,
              ),
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColor.secondaryBackground,
                border: Border.all(color: Colors.black12, width: 0.25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.search,
                    size: 22,
                  ),
                  HorizontalSpacing.d10px(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 2.0,
                        right: 2.0,
                      ),
                      child: Text(
                        placeholder ?? "Search Products and Deals",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.text,
                          fontFamily: AppTextStyle.fontFamily,
                        ),
                        textAlign: TextAlign.start,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
}
