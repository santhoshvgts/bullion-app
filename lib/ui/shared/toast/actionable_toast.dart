import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionableToast extends StatelessWidget {

  String title;
  String content;
  String? actionText;
  VoidCallback? onActionTap;
  IconData? icon;

  ActionableToast({super.key,  this.icon, required this.title, required this.content, this.onActionTap, this.actionText });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            // color: const Color(0xff092635),
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: AppStyle.cardShadow
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [

              if (icon != null)
                Icon(icon, color: AppColor.green, size: 35,),

              HorizontalSpacing.d10px(),

              Expanded(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(title, style: AppTextStyle.labelMedium,),
                    Text(content, style: AppTextStyle.bodyMedium,),

                  ],
                ),
              ),

              if (onActionTap != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Button.mini(actionText, width: 60,
                      textStyle: AppTextStyle.titleSmall,
                      color: AppColor.secondaryBackground,
                      borderColor: AppColor.secondaryBackground,
                      valueKey: const ValueKey("btnView"),
                      onPressed: onActionTap
                  ),
                )

            ],
          ),
        ),
      ],
    );
  }


}