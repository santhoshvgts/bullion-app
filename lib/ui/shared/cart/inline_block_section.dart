import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter/cupertino.dart';

class InlineBlockSection extends StatelessWidget {
  DisplayMessage data;

  InlineBlockSection(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: data.color.withOpacity(0.1),
            border: Border.all(color: data.color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                data.icon,
                color: data.color,
                size: 16,
              ),
              // if (data.title != null)
              //   Padding(
              //     padding: const EdgeInsets.only(bottom: 5),
              //     child: Text(data.title!,
              //         style: AppTextStyle.titleLarge.copyWith(
              //             fontSize: 14,
              //             color: data.color,
              //             fontWeight: FontWeight.w600),
              //         textAlign: TextAlign.start),
              //   ),

              HorizontalSpacing.d5px(),

              Expanded(
                child: Text(
                  data.message!,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: data.color,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
