import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  final String title;
  final Function? arrowPressed;
  final Widget? child;
  final Widget? trailing;
  final Color backgroundColor;
  final EdgeInsets margin;
  final EdgeInsets? padding;

  HeaderCard(this.title,
      {this.arrowPressed,
      this.backgroundColor = AppColor.white,
      this.child,
      this.trailing,
      this.padding,
      this.margin = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      margin: margin,
      child: Column(
        children: <Widget>[
          Container(
            padding: padding != null
                ? padding
                : child == null
                    ? EdgeInsets.all(15)
                    : EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  title,
                  
                  style: AppTextStyle.headlineSmall,
                )),
                trailing == null ? Container() : trailing!,
                arrowPressed == null
                    ? Container()
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColor.primary,
                        ),
                        onPressed: arrowPressed as void Function()?,
                      )
              ],
            ),
          ),
          child!,
        ],
      ),
    );
  }
}
