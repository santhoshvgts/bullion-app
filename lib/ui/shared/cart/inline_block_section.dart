import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter/cupertino.dart';

class InlineBlockSection extends StatelessWidget {
  final DisplayMessage? data;

  InlineBlockSection(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 5),
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: AppColor.secondaryBackground,
            border: Border(left: BorderSide(color: data!.color, width: 2))),
        child: Column(
          children: [
            if (data!.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(data!.title!,
                    style: AppTextStyle.titleLarge.copyWith(
                        fontSize: 14,
                        color: data!.color,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start),
              ),
            Text(
              data!.message!,
              style: AppTextStyle.bodyMedium.copyWith(
                  color: data!.textColor,
                  fontWeight: data!.title == null ? FontWeight.w600 : null),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
