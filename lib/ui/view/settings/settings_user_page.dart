import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/ui/view/settings/settings_user_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/res/colors.dart';
import '../../../core/res/styles.dart';
import '../../../helper/url_launcher.dart';
import '../../../locator.dart';
import '../../../router.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared/navigator_service.dart';
import '../../widgets/button.dart';

class SettingsUserPage extends VGTSBuilderWidget<SettingsUserViewModel> {
  const SettingsUserPage({super.key});

  @override
  void onViewModelReady(SettingsUserViewModel viewModel) {
    viewModel.refreshData();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(
    BuildContext context,
    AppLocalizations locale,
    SettingsUserViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          viewModel.isAuthenticated
              ? "Hi, ${locator<AuthenticationService>().getUser?.firstName ?? ""}"
              : "Account",
          style: AppTextStyle.titleLarge,
          textScaleFactor: 1,
        ),
      ),
      body: SingleChildScrollView(
          child: viewModel.isAuthenticated
              ? getAccountDetailsWidget(viewModel, context)
              : getAccountWidget(viewModel, context)),
    );
  }

  @override
  SettingsUserViewModel viewModelBuilder(BuildContext context) {
    return SettingsUserViewModel();
  }

  Widget getAccountDetailsWidget(
      SettingsUserViewModel viewModel, BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: AppColor.primary,
              height: 316,
              width: double.infinity,
            ),
            const SizedBox(height: 112),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text('Alerts', style: AppTextStyle.titleMedium),
                      ),
                      getTextsLayout(
                          const Icon(Icons.person), "Custom Spot Price"),
                      const Divider(
                        color: AppColor.platinumColor,
                      ),
                      getTextsLayout(
                        const Icon(Icons.person),
                        "Alert Me!",
                      ),
                      const Divider(
                        color: AppColor.platinumColor,
                      ),
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
              height: 24,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child:
                            Text('Activity', style: AppTextStyle.titleMedium),
                      ),
                      getTextsLayout(
                          const Icon(Icons.person), "Search History"),
                      const Divider(
                        color: AppColor.platinumColor,
                      ),
                      getTextsLayout(
                        const Icon(Icons.person),
                        "Recently Viewed",
                      ),
                      const Divider(
                        color: AppColor.platinumColor,
                      ),
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
            getFooterSection(context,
                isAuthenticated: viewModel.isAuthenticated),
          ],
        ),
        if (viewModel.isAuthenticated)
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Text(
                locator<AuthenticationService>().getUser?.email ?? "",
                style:
                    AppTextStyle.bodyMedium.copyWith(color: AppColor.mercury),
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: AppStyle.cardShadow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    locator<NavigationService>().pushNamed(Routes.myOrders);
                  },
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
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  'Track your order status or view your order history and receipts',
                                  style: AppTextStyle.bodyMedium
                                      .copyWith(color: AppColor.navyBlue40)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
        Positioned(
            top: 168,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text('Manage Account',
                            style: AppTextStyle.titleMedium),
                      ),
                      getTextsLayout(
                        const Icon(Icons.person),
                        "Personal Info",
                        "Profile, Change Email and password",
                      ),
                      const Divider(
                        color: AppColor.platinumColor,
                      ),
                      InkWell(
                        onTap: () {
                          locator<NavigationService>().pushNamed(Routes.address);
                        },
                        child: getTextsLayout(
                          const Icon(Icons.pin_drop_outlined),
                          "Addresses",
                        ),
                      ),
                      const Divider(
                        color: AppColor.platinumColor,
                      ),
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
    );
  }

  Widget getFooterSection(BuildContext context,
      {bool isAuthenticated = false}) {
    return Container(
      color: AppColor.accountBg,
      height: 516,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text('Privacy', style: AppTextStyle.titleMedium),
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
              child: Text('Contact Us', style: AppTextStyle.titleMedium),
            ),
            showContactInfo('Toll Free : ', '8003759006'),
            showContactInfo('Local Number : ', '405.595.2100'),
            showContactInfo('Email : ', 'service@bullion.com'),
            const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child:
                  Text('Hours of Operation', style: AppTextStyle.titleMedium),
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
            Visibility(
              visible: isAuthenticated,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Logout'),
                        content: const Text("Do you want to logout?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              locator<AuthenticationService>().logout("");
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Logout',
                      style: AppTextStyle.bodyMedium
                          .copyWith(color: AppColor.navyBlue40)),
                ),
              ),
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
    );
  }

  Widget getAccountWidget(
      SettingsUserViewModel viewModel, BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: AppColor.primary,
              height: 312,
              width: double.infinity,
            ),
            const SizedBox(height: 64),
            getFooterSection(context)
          ],
        ),
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
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
                      const Text(
                        'Sign in to do more with your account',
                        style: AppTextStyle.titleMedium,
                      ),
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
                      Button(
                        "Sign in or Create Account",
                        width: double.infinity,
                        color: AppColor.primary,
                        height: 42,
                        borderColor: AppColor.primary,
                        valueKey: const Key("btnSignInCreate"),
                        onPressed: () {
                          viewModel.showIntroScreen();
                        },
                      )
                    ],
                  ),
                ),
              ),
              VerticalSpacing.d15px(),
              Container(
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
              )
            ],
          ),
        ),
      ],
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

  Widget showContactInfo(String key, String contactValue) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Text(
            key,
            style: AppTextStyle.bodyMedium.copyWith(color: AppColor.navyBlue40),
          ),
          InkWell(
            onTap: () => launchAnUrl(contactValue.contains('@')
                ? "mailto:$contactValue"
                : "tel:$contactValue"),
            child: Text(
              contactValue,
              style:
                  AppTextStyle.bodyMedium.copyWith(color: AppColor.clearBlue),
            ),
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
              Text(text1, style: AppTextStyle.bodyMedium),
              if (text2 != null)
                Text(text2,
                    style: AppTextStyle.bodySmall
                        .copyWith(color: AppColor.navyBlue40)),
            ],
          ),
        ],
      ),
    );
  }
}
