import 'dart:io';

import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:flutter/material.dart';

class PageWillPop extends StatelessWidget {
  final Widget child;
  final bool allowPop;

  PageWillPop({required this.child, this.allowPop = true});

  @override
  Widget build(BuildContext context) {
    if (!this.allowPop) {
      return WillPopScope(child: child, onWillPop: () => Future.value(false));
    }

    if (Platform.isIOS) {
      return child;
    }

    return WillPopScope(
        child: child,
        onWillPop: () async {
          return !await locator<DialogService>().dialogNavigationKey.currentState!.maybePop();
        });
  }
}
