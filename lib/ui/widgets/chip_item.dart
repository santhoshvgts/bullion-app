import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter/material.dart';

class ChipItem extends StatelessWidget {
  String text;
  Function onTap;
  bool isSelected;

  ChipItem(
      {super.key,
      required this.text,
      required this.onTap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected ? AppColor.primary : AppColor.border,
              width: isSelected ? 2 : 1
            )
        ),
        child: Text(
          text,
          style: AppTextStyle.bodyMedium.copyWith(
            color: isSelected ? AppColor.primary : AppColor.secondaryText,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400
          ),
        ),
      ),
    );
  }
}
