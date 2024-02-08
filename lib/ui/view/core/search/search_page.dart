import 'package:bullion/core/models/module/search_module.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:bullion/ui/view/core/search/search_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

class SearchPage extends VGTSBuilderWidget<SearchViewModel> {
  const SearchPage({super.key});

  @override
  SearchViewModel viewModelBuilder(BuildContext context) => SearchViewModel();

  @override
  Widget viewBuilder(
    BuildContext context,
    AppLocalizations locale,
    SearchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBackground,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 1,
        title: Text("Search Bullion.com",  style: AppTextStyle.titleSmall.copyWith(color: AppColor.title, fontFamily: AppTextStyle.fontFamily),),
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 45),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColor.secondaryBackground,
                          border: Border.all(color: Colors.black12, width: 0.25),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search..',
                                    hintStyle: AppTextStyle.bodyMedium.copyWith(
                                      color: AppColor.text,
                                      fontFamily: AppTextStyle.fontFamily,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      bottom: 8,
                                      right: 10,
                                    ),
                                  ),
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColor.text,
                                    fontFamily: AppTextStyle.fontFamily,
                                  ),
                                  controller: viewModel.searchController.textEditingController,
                                  focusNode: viewModel.searchController.focusNode,
                                  autofocus: true,
                                  textAlign: TextAlign.start,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.search,
                                  onChanged: (val) => viewModel.onChange(val),
                                  onSubmitted: (val) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    if (val != "") {
                                      viewModel.navigate("/search?q=${val}");
                                    }
                                  },
                                )),

                            if (viewModel.searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  size: 20,
                                ),
                                onPressed: () {
                                  viewModel.searchController.clear();
                                  viewModel.notifyListeners();
                                },
                              )
                          ],
                        )),
                  ),
                ],
              ),
            )
        ),
      ),
      body: TapOutsideUnFocus(
        child: viewModel.searchController.text.isNotEmpty
            ? Container(
                color: AppColor.white,
                height: double.infinity,
                child: viewModel.searchList?.isNotEmpty == true
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: viewModel.searchList!
                              .asMap()
                              .map((index, item) {
                                return MapEntry(index, _Item(item));
                              })
                              .values
                              .toList(),
                        ))
                    : Container(),
              )
            : const ContentWrapper("/search/default"),
      ),
    );
  }
}

class _Item extends ViewModelWidget<SearchViewModel> {
  final SearchResult _item;
  _Item(this._item);

  @override
  Widget build(BuildContext context, SearchViewModel viewModel) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 15,
            top: 5,
            bottom: 5,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: InkWell(
                  onTap: () => viewModel.navigate(_item.targetUrl!),
                  child: RichText(
                    text: TextSpan(
                      children: viewModel.highlightOccurrences(
                        _item.name,
                        viewModel.searchController.text,
                      ),
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontFamily: AppTextStyle.fontFamily,
                        color: AppColor.text,
                      ),
                    ),
                  ),
                ),
              ),
              HorizontalSpacing.d10px(),
              Expanded(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.arrow_up_right),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      viewModel.searchName(_item.name!);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        AppStyle.customDivider
      ],
    );
  }
}
