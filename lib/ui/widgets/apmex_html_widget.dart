import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../core/res/styles.dart';

class ApmexHtmlWidget extends StatefulWidget {
  final String? content;
  final TextStyle textStyle;

  final bool enableReadMore;

  ApmexHtmlWidget(this.content, {this.textStyle = AppTextStyle.bodyMedium, this.enableReadMore = false });

  @override
  State<ApmexHtmlWidget> createState() => _ApmexHtmlWidgetState();
}

class _ApmexHtmlWidgetState extends State<ApmexHtmlWidget> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    Widget htmlWidget = HtmlWidget(
      widget.content!,
      textStyle: widget.textStyle,
      onTapUrl: (String url) {
        print(url);
        Uri uri = Uri.parse(url);
        print(uri.host);

        if (uri.host == "bullion.com" || !uri.isAbsolute) {
          locator<NavigationService>().pushNamed(
            Uri.parse(url).path,
          );
        } else {
          launchAnUrl(url.trim());
        }
        return true;
      },
      onTapImage: (ImageMetadata image) {},
    );

    if (widget.enableReadMore) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRect(
            child: SizedBox(
              height: isExpanded ? null : MediaQuery.of(context).size.height / 1.5,
              child: htmlWidget
            )
          ),

          VerticalSpacing.d10px(),

          InkWell(
            onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
            },
            child: Text(isExpanded ? "Show Less" : "Read More", textScaleFactor: 1, style: AppTextStyle.titleSmall.copyWith(color: AppColor.primary),)
          )

        ],
      );
    }

    return htmlWidget;
  }
}
