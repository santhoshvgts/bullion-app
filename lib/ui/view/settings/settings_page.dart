import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/view/settings/settings_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/res/styles.dart';

class SettingsPage extends VGTSBuilderWidget<SettingsViewModel> {
  const SettingsPage({super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      SettingsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Account",
          style: AppTextStyle.titleLarge,
          textScaleFactor: 1,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: AppColor.primary,
                  height: 312,
                  width: double.infinity,
                ),
                const SizedBox(height: 64),
                Container(
                  color: AppColor.accountBg,
                  height: 500,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child:
                              Text('Privacy', style: AppTextStyle.titleMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text('Visit Bullion.com',
                              style: AppTextStyle.bodyMedium
                                  .copyWith(color: AppColor.navyBlue40)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text("User Agreements",
                              style: AppTextStyle.bodyMedium
                                  .copyWith(color: AppColor.navyBlue40)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text('Privacy Policy',
                              style: AppTextStyle.bodyMedium
                                  .copyWith(color: AppColor.navyBlue40)),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Text('Contact Us',
                              style: AppTextStyle.titleMedium),
                        ),
                        getTextRowWithTopPadding(
                            'Toll Free : ', '800.375.9006'),
                        getTextRowWithTopPadding(
                            'Local Number : ', '405.595.2100'),
                        getTextRowWithTopPadding(
                            'Email : ', 'service@bullion.com'),
                        const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Text('Hours of Operation',
                              style: AppTextStyle.titleMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Monday - Thursday | 8 a.m - 8 p.m(EST)',
                              style: AppTextStyle.bodyMedium
                                  .copyWith(color: AppColor.navyBlue40)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Friday | 8 a.m - 6 p.m(EST)',
                              style: AppTextStyle.bodyMedium
                                  .copyWith(color: AppColor.navyBlue40)),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 48.0),
                            child: Text('Version 1.0.3 (10)',
                                style: AppTextStyle.bodySmall
                                    .copyWith(color: AppColor.navyBlue40)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sign in to do more with your account',
                            style: AppTextStyle.titleMedium),
                        const SizedBox(
                          height: 16,
                        ),
                        getTextsWithBullets([
                          'Easily manage your orders',
                          'Customize your profile',
                          'Track your portfolio and rewards',
                        ]),
                        const SizedBox(
                          height: 16,
                        ),
                        Button("Sign in or Create Account",
                            width: double.infinity,
                            color: AppColor.primary,
                            height: 42,
                            borderColor: AppColor.primary,
                            valueKey: const Key("btnSignInCreate"),
                            onPressed: () {
                          //viewModel.addProduct(viewModel);
                        })
                      ],
                    ),
                  ),
                )),
            Positioned(
                top: 264,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 96,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: AppStyle.elevatedCardShadow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.list),
                              SizedBox(width: 8),
                              Text('Order History',
                                  style: AppTextStyle.titleMedium),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Track your order status',
                                  style: AppTextStyle.bodyMedium
                                      .copyWith(color: AppColor.navyBlue40)),
                              Button("Track Order",
                                  width: 104,
                                  color: Colors.white,
                                  textStyle: AppTextStyle.titleSmall,
                                  height: 32,
                                  borderColor: AppColor.primary,
                                  valueKey: const Key("btnSignInCreate"),
                                  onPressed: () {
                                //viewModel.addProduct(viewModel);
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) {
    return SettingsViewModel();
  }

  Widget getTextRowWithTopPadding(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Text(
            text1,
            style: AppTextStyle.bodyMedium.copyWith(color: AppColor.navyBlue40),
          ),
          Text(
            text2,
            style: AppTextStyle.bodyMedium.copyWith(color: AppColor.clearBlue),
          ),
        ],
      ),
    );
  }

  Widget getTextsWithBullets(List<String> texts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts
          .map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('\u2022'),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                      text,
                      style: AppTextStyle.bodyMedium
                          .copyWith(color: AppColor.navyBlue40),
                    )),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
