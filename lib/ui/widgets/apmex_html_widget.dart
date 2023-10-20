import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../core/res/styles.dart';

class ApmexHtmlWidget extends StatelessWidget {
  final String? content;
  final TextStyle textStyle;

  ApmexHtmlWidget(this.content, {this.textStyle = AppTextStyle.bodyMedium});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      content!,
      textStyle: textStyle,
      onTapUrl: (String url) {
        print(url);
        Uri uri = Uri.parse(url);
        print(uri.host);

        if (uri.host == "apmex.com" || !uri.isAbsolute) {
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
  }
}
