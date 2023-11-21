import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:flutter/cupertino.dart';

class WarningCard extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  WarningCard(this.text, {this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      color: AppColor.white,
      child: Container(
          decoration: BoxDecoration(
              color: AppColor.secondaryBackground,
              border: Border(
                  left: BorderSide(color: color ?? AppColor.red, width: 2))),
          padding: EdgeInsets.all(10),
          child: ApmexHtmlWidget(
            text,
            textStyle: AppTextStyle.bodyMedium
                .copyWith(color: textColor ?? AppColor.red),
          )),
    );
  }
}
