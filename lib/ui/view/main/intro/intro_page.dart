import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';

import 'package:bullion/ui/view/main/intro/intro_view_model.dart';
import 'package:bullion/ui/view/main/intro/widgets/_page_indicator.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';

class IntroPage extends VGTSBuilderWidget<IntroViewModel> {
  const IntroPage({super.key});

  @override
  Widget viewBuilder(BuildContext context, locale, IntroViewModel viewModel, Widget? child) {
    return Scaffold(
      //
      //
      appBar: AppBar(
        elevation: 0,
        actions: [
          InkWell(
            onTap: viewModel.skipOnPressed,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            child: Container(
              margin: const EdgeInsets.only(top: 12, right: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColor.border)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                child: Text(
                  'Skip',
                  style: AppTextStyle.normal.copyWith(color: AppColor.greenText, fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      //
      //
      body: SafeArea(
        child: PageView.builder(
          itemCount: viewModel.introSliderItems.length,
          controller: viewModel.pageController,
          physics: const ClampingScrollPhysics(),
          onPageChanged: (value) {
            viewModel.currentPageIndex = value;
            viewModel.notifyListeners();
          },
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(viewModel.introSliderItems[index].image),
                const Spacer(),
                Text(
                  viewModel.introSliderItems[index].title,
                  style: AppTextStyle.normal.copyWith(color: AppColor.text, fontSize: 18),
                ),
                VerticalSpacing.custom(value: 8),
                Text(
                  viewModel.introSliderItems[index].description,
                  style: AppTextStyle.normal.copyWith(fontSize: 14, color: AppColor.primaryText, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                VerticalSpacing.d20px()
              ],
            ),
          ),
        ),
      ),
      //
      //
      bottomNavigationBar: SafeArea(
        child: Wrap(children: [
          PageIndicator(activeIndex: viewModel.currentPageIndex),
          VerticalSpacing.custom(value: 33),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: viewModel.isLastindex ? 0 : 62),
            child: Button(viewModel.buttonName, width: double.infinity, valueKey: const ValueKey("btnLogin"), onPressed: viewModel.introButtonOnPressed),
          ),
          viewModel.isLastindex
              ? Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 21),
                  child: InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: viewModel.register,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account ?',
                          style: AppTextStyle.normal.copyWith(
                            color: AppColor.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        HorizontalSpacing.custom(value: 8),
                        Text(
                          'Sign Up',
                          style: AppTextStyle.normal.copyWith(
                            color: AppColor.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ]),
      ),
    );
  }

  @override
  IntroViewModel viewModelBuilder(BuildContext context) {
    return IntroViewModel();
  }
}
