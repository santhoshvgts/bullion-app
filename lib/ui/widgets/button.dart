import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/utils.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Key valueKey;
  final String? text;

  String? image;
  String? icon;

  TextStyle? textStyle;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final Color color;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final bool disabled;
  final bool loading;
  final Widget? iconWidget;

  Button(
    this.text, {
    super.key,
    required this.valueKey,
    this.textStyle,
    this.width = 160,
    this.height = 42,
    required this.onPressed,
    this.color = AppColor.primary,
    this.borderColor = AppColor.primary,
    this.borderRadius,
    this.iconWidget,
    this.disabled = false,
    this.loading = false,
  });

  Button.outline(
    this.text, {
    super.key,
    required this.valueKey,
    this.textStyle,
    this.width = 160,
    this.height = 42,
    required this.onPressed,
    this.color = Colors.transparent,
    this.borderColor = AppColor.outlineBorder,
    this.borderRadius,
    this.disabled = false,
    this.iconWidget,
    this.loading = false,
  });

  Button.image(
    this.image,
    this.icon, {
    super.key,
    required this.valueKey,
    this.textStyle,
    this.width = 160,
    this.height = 42,
    this.text = "",
    required this.onPressed,
    this.color = Colors.transparent,
    this.borderColor = AppColor.primary,
    this.borderRadius,
    this.disabled = false,
    this.iconWidget,
    this.loading = false,
  });

  Button.mini(
      this.text,{
        super.key,
        required this.valueKey,
        this.textStyle,
        this.width = 100,
        this.height = 30,
        required this.onPressed,
        this.color = Colors.transparent,
        this.borderColor = AppColor.primary,
        this.borderRadius,
        this.disabled = false,
        this.iconWidget,
        this.loading = false,
      });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: disabled ? Colors.black12 : color,
          borderRadius: borderRadius ?? BorderRadius.circular(100),
          border: disabled ? null : Border.all(color: borderColor, width: 0.6)),
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: image != null
            ? InkWell(
                onTap: disabled || loading ? null : onPressed,
                child: loading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(AppColor.white),
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FAIcon(icon),
                                color: AppColor.white,
                              ),
                              HorizontalSpacing.d10px(),
                              Image.asset(
                                image!,
                                color: AppColor.white,
                              ),
                            ],
                          ),
                        ),
                      ),
              )
            : MaterialButton(
                key: valueKey,
                onPressed: disabled || loading ? null : onPressed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColor.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (iconWidget != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: iconWidget!,
                            ),
                          Text(
                            text!,
                            
                            maxLines: 1,
                            style: (disabled
                                    ? textStyle?.copyWith(color: Colors.black26)
                                    : textStyle) ??
                                AppTextStyle.titleSmall.copyWith(
                                  color: Colors.white,
                                ),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
