import 'package:bullion/core/models/module/page_settings.dart';
import 'package:flutter/cupertino.dart';

class PageStorageService {
  final PageStorageBucket bucket = PageStorageBucket();

  PageSettings? read(BuildContext context, Key? _key) {
    PageSettings? settings =
        bucket.readState(context, identifier: ValueKey(_key));
    return settings;
  }

  write(BuildContext context, Key? _key, PageSettings? _pageSettings) {
    bucket.writeState(context, _pageSettings, identifier: ValueKey(_key));
    return;
  }
}
