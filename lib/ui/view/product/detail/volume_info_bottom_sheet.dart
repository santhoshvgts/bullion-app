import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VolumeInfoBottomSheet extends StatelessWidget {

 final String? text;

  VolumeInfoBottomSheet(this.text);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), child: ApmexHtmlWidget(text, textStyle:AppTextStyle.bodyMedium.copyWith(height:1.8),),)
        ],
      ),
    );
  }
}