import 'dart:io';

import 'package:bullion/core/models/alert/alert_add_response_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/res/colors.dart';
import '../../../../core/res/styles.dart';
import '../../../../helper/utils.dart';
import '../../../widgets/animated_flexible_space.dart';
import 'create_alerts_view_model.dart';

class AddEditSpotPricePage extends VGTSBuilderWidget<CreateAlertsViewModel> {
  final AlertResponseModel? alertResponse;
  final String? metalName;

  const AddEditSpotPricePage({super.key, this.alertResponse, this.metalName});

  @override
  void onViewModelReady(CreateAlertsViewModel viewModel) {
    viewModel.init(alertResponse, metalName);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return TapOutsideUnFocus(
      child: Scaffold(
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Platform.isAndroid
                    ? const Icon(Icons.arrow_back)
                    : const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              expandedHeight: 100,
              pinned: true,
              flexibleSpace:
                  const AnimatedFlexibleSpace.withoutTab(title: "Custom Spot Price"),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                  ? LoadingData(
                      loadingStyle: LoadingStyle.LOGO,
                    )
                  : viewModel.operatorsResponse == null
                      ? const Center(child: Text("No data available"))
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Padding(
                                  padding: EdgeInsets.only( bottom: 8.0),
                                  child: Text(
                                    "Metal",
                                    style: AppTextStyle.titleSmall,
                                  ),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: List<Widget>.generate(
                                    viewModel.metalsList.length,
                                    (int index) {
                                      return ChoiceChip(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        label: Text(viewModel.metalsList[index]),
                                        labelStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.primaryText),
                                        color: MaterialStateProperty.resolveWith((states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return AppColor.primary.withOpacity(0.08);
                                          }
                                          return Colors.white;
                                        }),
                                        side: MaterialStateBorderSide.resolveWith((Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return const BorderSide(
                                                width: 1.0,
                                                color: AppColor.primary
                                            );
                                          }
                                          return const BorderSide(
                                              width: 1.0,
                                              color: AppColor.border);
                                        }),
                                        checkmarkColor: AppColor.primary,
                                        backgroundColor: Colors.white,
                                        selected: index ==
                                            viewModel.metalsSelectedIndex,
                                        onSelected: (value) {
                                          viewModel.metalsSelectedIndex =
                                              value ? index : 0;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: Text(
                                    "Options",
                                    style: AppTextStyle.titleSmall,
                                  ),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: List<Widget>.generate(
                                    viewModel.operatorsResponse!.operators!.length,
                                    (int index) {
                                      return ChoiceChip(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
                                        label: Text(viewModel.operatorsResponse!.operators![index].description!),
                                        labelStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.primaryText),
                                        color: MaterialStateProperty.resolveWith((states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return AppColor.primary.withOpacity(0.08);
                                          }
                                          return Colors.white;
                                        }),
                                        side:
                                            MaterialStateBorderSide.resolveWith(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return const BorderSide(
                                                width: 1.0,
                                                color: AppColor.primary
                                            );
                                          }
                                          return const BorderSide(
                                              width: 1.0,
                                              color: AppColor.border
                                          );
                                        }),
                                        checkmarkColor: AppColor.primary,
                                        backgroundColor: Colors.white,
                                        selected: index ==
                                            viewModel.optionsSelectedIndex,
                                        onSelected: (value) {
                                          viewModel.optionsSelectedIndex =
                                              value ? index : 0;
                                        },
                                      );
                                    },
                                  ),
                                ),

                                Form(
                                  key: viewModel.customSpotPriceGlobalKey,
                                  child: EditTextField(
                                    "${viewModel.operatorsResponse?.operators?[viewModel.optionsSelectedIndex].description}",
                                    viewModel.alertPriceFormFieldController,
                                    textStyle: AppTextStyle.titleLarge,
                                    autoFocus: true,
                                    margin: const EdgeInsets.only(top: 30, right: 10, left: 5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
            )
          ],
        )),
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Button(
                color: AppColor.primary,
                alertResponse == null ? "Create" : "Update",
                valueKey: const Key("btnCreate"),
                borderRadius: BorderRadius.circular(24),
                onPressed: () async {
                  if (viewModel.customSpotPriceGlobalKey.currentState!
                      .validate()) {
                    bool result = await viewModel.createEditMarketAlert();
                    if (result) {
                      Util.showSnackBar("Submitted successfully");
                      Navigator.of(context).pop();
                    }
                  } else {
                    Util.showSnackBar("Fill all the required fields");
                  }
                },
                disabled: viewModel.operatorsResponse == null,
              )),
        ),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return CreateAlertsViewModel();
  }
}
