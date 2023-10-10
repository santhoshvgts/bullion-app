import 'package:bullion/core/models/module/search_module.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/api_request/page_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class SearchViewModel extends VGTSBaseViewModel {
  TextFormFieldController searchController = TextFormFieldController(
    const ValueKey("txtSearch"),
  );

  List<SearchResult>? _searchList;

  List<SearchResult>? get searchList => _searchList;

  void onChange(String data) {
    Future(() async {
      _searchList =
          await requestList<SearchResult>(PageRequest.search(text: data));
      notifyListeners();
    });
  }

  navigate(String targetUrl) {
    FocusScope.of(navigationService.navigatorKey.currentContext!)
        .requestFocus(FocusNode());
    navigationService.pushAndPopUntil(
      targetUrl,
      removeRouteName: Routes.dashboard,
    );
  }

  searchName(String name) {
    searchController.text = name;
    searchController.textEditingController.selection = TextSelection(
        baseOffset: searchController.text.length,
        extentOffset: searchController.text.length);
    onChange(searchController.text);
    notifyListeners();
  }

  List<TextSpan> highlightOccurrences(String? name, String search) {
    if (search == null ||
        search.isEmpty ||
        !name!.toLowerCase().contains(search.toLowerCase())) {
      return [TextSpan(text: name)];
    }
    final matches = search.toLowerCase().allMatches(name.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: name.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: name.substring(
          match.start,
          match.end,
        ),
        style: AppTextStyle.bodyMedium
            .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      ));

      if (i == matches.length - 1 && match.end != name.length) {
        children.add(TextSpan(
          text: name.substring(match.end, name.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
}
