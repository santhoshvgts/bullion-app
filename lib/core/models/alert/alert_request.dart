import 'package:flutter/material.dart';

class AlertRequest {
  final String? title;
  final String? description;
  final String? buttonTitle;

  final Widget? iconWidget;
  final Widget? contentWidget;
  final bool? showActionBar;
  final bool? showCloseIcon;
  final bool? isDismissible;
  final bool? enableDrag;
  final bool? showDivider;
  final Alignment? headerAlignment;

  AlertRequest({this.title, this.description, this.buttonTitle, this.iconWidget, this.showActionBar, this.contentWidget, this.showCloseIcon, this.isDismissible, this.enableDrag, this.showDivider, this.headerAlignment});
}
