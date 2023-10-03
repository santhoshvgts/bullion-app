import 'package:bullion/ui/view/settings/settings_user_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/res/colors.dart';
import '../../../core/res/styles.dart';

class SettingsUserPage extends VGTSBuilderWidget<SettingsUserViewModel> {
  const SettingsUserPage({super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      SettingsUserViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Hi, User",
          style: AppTextStyle.headerWhite,
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
                const SizedBox(height: 112),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text('Alerts', style: AppTextStyle.titleMed),
                          ),
                          getTextsLayout(
                              const Icon(Icons.person), "Custom Spot Price"),
                          const Divider(),
                          getTextsLayout(
                            const Icon(Icons.person),
                            "Alert Me!",
                          ),
                          const Divider(),
                          getTextsLayout(
                            const Icon(Icons.person),
                            "Price Alert",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child:
                                Text('Activity', style: AppTextStyle.titleMed),
                          ),
                          getTextsLayout(
                              const Icon(Icons.person), "Search History"),
                          const Divider(),
                          getTextsLayout(
                            const Icon(Icons.person),
                            "Recently Viewed",
                          ),
                          const Divider(),
                          getTextsLayout(
                            const Icon(Icons.person),
                            "Buy Again",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
                              Text('Privacy', style: AppTextStyle.titleMed18),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text('Visit Bullion.com',
                              style: AppTextStyle.privacySubTitle),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text("User Agreements",
                              style: AppTextStyle.privacySubTitle),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text('Privacy Policy',
                              style: AppTextStyle.privacySubTitle),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Text('Contact Us',
                              style: AppTextStyle.titleMed18),
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
                              style: AppTextStyle.privacySubTitleBold),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text('Monday - Thursday | 8 a.m - 8 p.m(EST)',
                              style: AppTextStyle.privacySubTitle),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text('Friday | 8 a.m - 6 p.m(EST)',
                              style: AppTextStyle.privacySubTitle),
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 48.0),
                            child: Text('Version 1.0.3 (10)',
                                style: AppTextStyle.version),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Text(
                  "username@mail.com",
                  style: AppTextStyle.email,
                  textAlign: TextAlign.center,
                )),
            Positioned(
                top: 32,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 116,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.list),
                              SizedBox(width: 8),
                              Text('Order History',
                                  style: AppTextStyle.titleMed),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                    'Track your order status or view your order history and receipts',
                                    style: AppTextStyle.subTitleReg),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: 160,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text('Manage Account',
                                style: AppTextStyle.titleMed),
                          ),
                          getTextsLayout(
                            const Icon(Icons.person),
                            "Personal Info",
                            "Profile, Change Email and password",
                          ),
                          const Divider(),
                          getTextsLayout(
                            const Icon(Icons.pin_drop_outlined),
                            "Addresses",
                          ),
                          const Divider(),
                          getTextsLayout(
                            const Icon(Icons.favorite_border),
                            "Favorites",
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
  SettingsUserViewModel viewModelBuilder(BuildContext context) {
    return SettingsUserViewModel();
  }

  Widget getTextRowWithTopPadding(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Text(
            text1,
            style: AppTextStyle.privacySubTitle,
          ),
          Text(
            text2,
            style: AppTextStyle.privacyValue,
          ),
        ],
      ),
    );
  }

  Widget getTextsLayout(Icon icon, String text1, [String? text2]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: icon,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1, style: AppTextStyle.subTitleRegOpaque),
              if (text2 != null) Text(text2, style: AppTextStyle.subTitleReg),
            ],
          ),
        ],
      ),
    );
  }
}
