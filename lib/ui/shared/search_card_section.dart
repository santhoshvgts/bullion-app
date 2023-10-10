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

  SearchCardSection(
      {super.key,
      this.height,
      this.rightPadding,
      this.leftPadding,
      this.placeholder})
      : super(
          preferredSize: Size(double.infinity, height ?? 40),
          child: InkWell(
            onTap: () {
              locator<NavigationService>().pushNamed(Routes.search);
            },
            child: Container(
              height: height ?? 40,
              margin: EdgeInsets.only(
                left: leftPadding ?? 15,
                right: rightPadding ?? 15,
              ),
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: AppColor.secondaryBackground,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black12),
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
                        style: AppTextStyle.labelMedium.copyWith(
                          fontSize: 16,
                          color: AppColor.secondaryText,
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
