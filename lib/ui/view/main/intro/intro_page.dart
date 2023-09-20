import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';

import 'package:bullion/ui/view/main/intro/intro_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';

class IntroPage extends VGTSBuilderWidget<IntroViewModel> {
  const IntroPage({super.key});

  @override
  Widget viewBuilder(BuildContext context, locale, IntroViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          InkWell(
            onTap: viewModel.skipOnPressed,
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
      body: SafeArea(
        child: PageView.builder(
          itemCount: viewModel.introSliderItems.length,
          controller: viewModel.pageController,
          onPageChanged: (value) {
            viewModel.index = value;
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
      bottomNavigationBar: SafeArea(
        child: Wrap(children: [
          PageIndicator(activeIndex: viewModel.index),
          VerticalSpacing.custom(value: 33),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: viewModel.isLastindex ? 0 : 62),
            child: Button(viewModel.buttonName, width: double.infinity, valueKey: const ValueKey("btnLogin"), onPressed: viewModel.introButtonOnPressed),
          ),
          viewModel.isLastindex
              ? Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 21),
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

class Dot extends StatelessWidget {
  final double size;
  final Color color;

  const Dot({super.key, this.size = 10.0, this.color = const Color(0xff626A7D)});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int activeIndex;

  const PageIndicator({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Dot(
            size: activeIndex == index ? 8.0 : 5.0,
            color: const Color(0xFF626A7D).withOpacity(activeIndex == index ? 1.0 : 0.24),
          ),
        );
      }),
    );
  }
}
