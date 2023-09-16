import 'package:flutter/material.dart';
import 'package:bullion/core/res/styles.dart';

class CartSummaryHelpText extends StatelessWidget {

  final String? helpText;

  CartSummaryHelpText(this.helpText);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          helpText!,
          style: AppTextStyle.body,
        ),
      ),
    );
  }
}
