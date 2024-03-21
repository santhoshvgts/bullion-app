import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SortBottomSheet extends VGTSBuilderWidget<SortViewModel> {
  List<SelectedItemList>? sortOptionList;
  SortBottomSheet(this.sortOptionList);

  @override
  SortViewModel viewModelBuilder(BuildContext context) => new SortViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      SortViewModel viewModel, Widget? child) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.2,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColor.white,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: sortOptionList!
                            .asMap()
                            .map((index, item) {
                              return MapEntry(
                                  index,
                                  InkWell(
                                    onTap: () async {
                                      // ProductModel productModel = await viewModel.filter(item.value);
                                      locator<DialogService>().dialogComplete(
                                          AlertResponse(
                                              status: true, data: item.value));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.text!,
                                              style: AppTextStyle.bodyMedium
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                              
                                            ),
                                            Icon(
                                              Icons.check,
                                              color: item.selected!
                                                  ? AppColor.green
                                                  : AppColor
                                                      .secondaryBackground,
                                              size: 17,
                                            ),
                                          ]),
                                    ),
                                  ));
                            })
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          if (viewModel.isBusy)
            Container(
              color: AppColor.white.withOpacity(0.7),
              height: MediaQuery.of(context).size.height - 20,
              child: const Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColor.primary),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.sort),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Sort By",
                       style: AppTextStyle.titleLarge),
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => Navigator.pop(context))
            ],
          ),
          Container(height: 1, child: AppStyle.customDivider)
        ],
      ),
    );
  }
}

class SortViewModel extends VGTSBaseViewModel {}
