import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/ui/view/settings/settings_user_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.white),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: StreamBuilder<User?>(
          stream: locator<AuthenticationService>().userController.stream,
          builder: (context, snapshot) {
            User? user = snapshot.data;

            if (user == null) {
              return Text("Account Settings", style: AppTextStyle.titleMedium.copyWith(fontFamily: AppTextStyle.fontFamily,));
            }

            return Column(
              children: [
                Text("Hi, ${locator<AuthenticationService>().getUser?.firstName ?? ""}",
                  style: AppTextStyle.titleMedium.copyWith(
                    fontFamily: AppTextStyle.fontFamily,
                  ),
                ),
                Text(locator<AuthenticationService>().getUser?.email ?? "",
                  style: AppTextStyle.bodySmall.copyWith(
                    fontFamily: AppTextStyle.fontFamily,
                  ),
                ),
              ],
            );
          }
        ),
      ),
      body: SingleChildScrollView(
        child: viewModel.isAuthenticated
            ? getAccountDetailsWidget(viewModel, context)
            : getAccountWidget(viewModel, context),
      ),
    );
  }

  @override
  SettingsUserViewModel viewModelBuilder(BuildContext context) {
    return SettingsUserViewModel();
  }

  Widget getAccountDetailsWidget(SettingsUserViewModel viewModel, BuildContext context) {
    return Column(
      children: [

        Stack(
          children: [

            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 260,
                  color: AppColor.primary,
                )
            ),

            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  VerticalSpacing.d10px(),

                  _buildOrderSection(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: AppStyle.elevatedCardShadow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                            const Icon(FeatherIcons.user, size: 20),
                            "Personal Info",
                          ),
                          const Divider(
                            color: AppColor.platinumColor,
                          ),
                          InkWell(
                            onTap: () {
                              locator<NavigationService>().pushNamed(Routes.address);
                            },
                            child: getTextsLayout(
                              const Icon(Icons.pin_drop_outlined, size: 20),
                              "Addresses",
                            ),
                          ),
                          const Divider(
                            color: AppColor.platinumColor,
                          ),
                          InkWell(
                            onTap: () {
                              locator<NavigationService>()
                                  .pushNamed(Routes.favorites);
                            },
                            child: getTextsLayout(
                              const Icon(Icons.favorite_border, size: 20),
                              "Favorites",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),



            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   bottom: 0,
            //   child: Column(
            //     children: [
            //       Text(
            //         locator<AuthenticationService>().getUser?.email ?? "",
            //         style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mercury),
            //         textAlign: TextAlign.center,
            //       ),
            //
            //       _buildOrderSection(),
            //     ],
            //   ),
            // ),
            //
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     width: double.infinity,
            //     margin: const EdgeInsets.symmetric(horizontal: 16),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         boxShadow: AppStyle.elevatedCardShadow,
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Padding(
            //               padding: EdgeInsets.only(bottom: 16.0),
            //               child: Text('Manage Account',
            //                   style: AppTextStyle.titleMedium),
            //             ),
            //             getTextsLayout(
            //               const Icon(FeatherIcons.user, size: 20),
            //               "Personal Info",
            //             ),
            //             const Divider(
            //               color: AppColor.platinumColor,
            //             ),
            //             InkWell(
            //               onTap: () {
            //                 locator<NavigationService>().pushNamed(Routes.address);
            //               },
            //               child: getTextsLayout(
            //                 const Icon(Icons.pin_drop_outlined, size: 20),
            //                 "Addresses",
            //               ),
            //             ),
            //             const Divider(
            //               color: AppColor.platinumColor,
            //             ),
            //             InkWell(
            //               onTap: () {
            //                 locator<NavigationService>()
            //                     .pushNamed(Routes.favorites);
            //               },
            //               child: getTextsLayout(
            //                 const Icon(Icons.favorite_border, size: 20),
            //                 "Favorites",
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),

        VerticalSpacing.d15px(),

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
                  InkWell(
                    onTap: () {
                      locator<NavigationService>()
                          .pushNamed(Routes.alerts, arguments: 0);
                    },
                    child: getTextsLayout(
                        const Icon(CupertinoIcons.alarm, size: 20),
                        "Custom Spot Price"),
                  ),
                  const Divider(
                    color: AppColor.platinumColor,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>()
                          .pushNamed(Routes.alerts, arguments: 1);
                    },
                    child: getTextsLayout(
                      const Icon(Icons.attach_money, size: 20),
                      "Price Alert",
                    ),
                  ),
                  const Divider(
                    color: AppColor.platinumColor,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>()
                          .pushNamed(Routes.alerts, arguments: 2);
                    },
                    child: getTextsLayout(
                      const Icon(CupertinoIcons.bell, size: 20),
                      "Alert Me!",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        VerticalSpacing.d15px(),

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
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.searchHistory);
                    },
                    child: getTextsLayout(
                      const Icon(FeatherIcons.search, size: 20),
                      "Search History",
                    ),
                  ),
                  const Divider(
                    color: AppColor.platinumColor,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.recentlyViewed);
                    },
                    child: getTextsLayout(
                      const Icon(FeatherIcons.activity, size: 20),
                      "Recently Viewed",
                    ),
                  ),
                  const Divider(
                    color: AppColor.platinumColor,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.recentlyBought);
                    },
                    child: getTextsLayout(
                      const Icon(FeatherIcons.shoppingCart, size: 20),
                      "Buy Again",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        VerticalSpacing.d15px(),

        getFooterSection(context, isAuthenticated: viewModel.isAuthenticated),

      ],
    );
  }

  Widget getFooterSection(
    BuildContext context, {
    bool isAuthenticated = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

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
                    Text('Privacy', style: AppTextStyle.titleMedium),
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.searchHistory);
                    },
                    child: getTextsLayout(null, "Visit Bullion.com",),
                  ),
                  const Divider(
                    color: AppColor.platinumColor,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.recentlyViewed);
                    },
                    child: getTextsLayout(
                      null,
                      "User Agreements",
                    ),
                  ),
                  const Divider(
                    color: AppColor.platinumColor,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.recentlyBought);
                    },
                    child: getTextsLayout(
                      null,
                      "Privacy Policy",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        VerticalSpacing.d15px(),

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
                    Text('Contact Us', style: AppTextStyle.titleMedium),
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.searchHistory);
                    },
                    child: getTextsLayout(null, "Toll Free: 8003759006",),
                  ),
                  const Divider(
                    color: AppColor.platinumColor,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.recentlyViewed);
                    },
                    child: getTextsLayout(
                      null,
                      "Local Number : 405.595.2100",
                    ),
                  ),
                  const Divider(color: AppColor.platinumColor,),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.recentlyBought);
                    },
                    child: getTextsLayout(
                      null,
                      "Email : service@bullion.com",
                    ),
                  ),

                  const Divider(color: AppColor.platinumColor,),

                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(Routes.searchHistory);
                    },
                    child: getTextsLayout(null, "Monday - Thursday | 8 a.m - 8 p.m(EST)\nFriday | 8 a.m - 6 p.m(EST)",),
                  ),
                ],
              ),
            ),
          ),
        ),

        VerticalSpacing.d15px(),

        Visibility(
          visible: isAuthenticated,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  child: getTextsLayout(const Icon(CupertinoIcons.power, size: 20,), "Logout",),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 48.0, bottom: 15),
          child: Text('App Version - 1.0.3 (10)',
              style: AppTextStyle.bodySmall
                  .copyWith(color: AppColor.secondaryText)),
        )
      ],
    );
  }

  Widget getAccountWidget(
    SettingsUserViewModel viewModel,
    BuildContext context,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: AppColor.primary,
              height: 280,
              width: double.infinity,
            ),
            const SizedBox(height: 64),
            getFooterSection(context)
          ],
        ),
        Positioned(
          top: 5,
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
              _buildOrderSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppStyle.elevatedCardShadow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order History',
                style: AppTextStyle.titleMedium,
              ),
              VerticalSpacing.custom(value: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Track your order status or view your order history and receipts",
                      style: AppTextStyle.bodySmall
                          .copyWith(color: AppColor.secondaryText),
                    ),
                  ),
                  Button(
                    "Track Order",
                    width: 104,
                    color: Colors.white,
                    textStyle: AppTextStyle.titleSmall,
                    height: 32,
                    borderColor: AppColor.primary,
                    valueKey: const Key("btnSignInCreate"),
                    onPressed: () {
                      if (!locator<AuthenticationService>().isAuthenticated) {
                        Util.showLoginAlert();
                        return;
                      }
                      locator<NavigationService>().pushNamed(Routes.myOrders);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextsWithBullets(List<String> texts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts
          .map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('\u2022'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        text,
                        style: AppTextStyle.bodyMedium
                            .copyWith(color: AppColor.secondaryText),
                      ),
                    ),
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
            style:
                AppTextStyle.bodyMedium.copyWith(color: AppColor.secondaryText),
          ),
          InkWell(
            onTap: () => launchAnUrl(contactValue.contains('@')
                ? "mailto:$contactValue"
                : "tel:$contactValue"),
            child: Text(
              contactValue,
              style: AppTextStyle.bodyMedium.copyWith(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTextsLayout(Icon? icon, String text1, [String? text2]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [

          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: icon,
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1, style: AppTextStyle.bodyMedium),
              if (text2 != null)
                Text(
                  text2,
                  style: AppTextStyle.bodySmall
                      .copyWith(color: AppColor.secondaryText),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
