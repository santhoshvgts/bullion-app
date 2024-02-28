import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:flutter/material.dart';

class WarningCard extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  WarningCard(this.text, {this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 16,
              ),
              HorizontalSpacing.d5px(),
              Expanded(
                child: ApmexHtmlWidget(
                  text,
                  textStyle: AppTextStyle.bodySmall.copyWith(
                    color: Colors.orange,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
