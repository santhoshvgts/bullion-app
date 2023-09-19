import 'package:flutter/material.dart';

/// Simple wrapper that will clear focus when a tap is detected outside its boundaries
class TapOutsideUnFocus extends StatelessWidget {
  final Widget child;
  final Function? onTap;

  const TapOutsideUnFocus({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap as void Function()? ??
            () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
        child: this.child);
  }
}
