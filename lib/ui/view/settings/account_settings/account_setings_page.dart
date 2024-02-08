import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/settings/account_settings/account_settings_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/animated_flexible_space.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';
import '../../../../../locator.dart';
import '../../../../../router.dart';

class AccountSettingsPage extends VGTSBuilderWidget<AccountSettingsViewModel> {

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, AccountSettingsViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Util.showArrowBackward(),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              expandedHeight: 100,
              pinned: true,
              flexibleSpace:
              const AnimatedFlexibleSpace.withoutTab(title: "Personal Info"),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                  ? LoadingData(
                loadingStyle: LoadingStyle.LOGO,
              ) : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [

                    _PersonalInfoSection(),

                    VerticalSpacing.d15px(),

                    _EmailInfoSection(),

                    VerticalSpacing.d15px(),

                    _PasswordInfoSection()
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  @override
  AccountSettingsViewModel viewModelBuilder(BuildContext context) {
    return AccountSettingsViewModel();
  }

}

class _PersonalInfoSection extends ViewModelWidget<AccountSettingsViewModel> {

  @override
  Widget build(BuildContext context, AccountSettingsViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppStyle.elevatedCardShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            children: [
              Expanded(child: _buildItemSection("Name",
                  viewModel.profile?.user?.fullName ?? "-")
              ),

              Button.mini("Edit",
                  width: 70,
                  valueKey: const ValueKey("btnProfileEdit"),
                  textStyle: AppTextStyle.labelMedium.copyWith(color: AppColor.primary),
                  onPressed: () async {
                    var response = await locator<NavigationService>().pushNamed(Routes.myProfile);
                    if (response != null) {
                      viewModel.fetchProfile();
                    }
                  }
              )

            ],
          ),

          AppStyle.customDivider,

          _buildItemSection("Phone Number", viewModel.profile?.phoneNumber ?? '-'),

          // AppStyle.customDivider,
          //
          // _buildItemSection("Alternate Number", viewModel.profile?.alternatePhoneNumber ?? '-'),
          //
          // AppStyle.customDivider,
          //
          // _buildItemSection("Company", viewModel.profile?.companyName ?? '-'),

        ],
      ),
    );
  }

}

class _EmailInfoSection extends ViewModelWidget<AccountSettingsViewModel> {

  @override
  Widget build(BuildContext context, AccountSettingsViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppStyle.elevatedCardShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(child: _buildItemSection("Email", viewModel.profile?.user?.email ?? '')),

          Button.mini("Change",
              width: 85,
              valueKey: const ValueKey("btnChangeEmail"),
              textStyle: AppTextStyle.labelMedium.copyWith(color: AppColor.primary),
              onPressed: () async {
                var response = await locator<NavigationService>().pushNamed(Routes.changeEmail);
                if (response != null) {
                  viewModel.fetchProfile();
                }
              }
          )

        ],
      ),
    );
  }

}

class _PasswordInfoSection extends ViewModelWidget<AccountSettingsViewModel> {

  @override
  Widget build(BuildContext context, AccountSettingsViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppStyle.elevatedCardShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(child: _buildItemSection("Password", "***********")),

          Button.mini("Change",
              width: 85,
              valueKey: const ValueKey("btnChange"),
              textStyle: AppTextStyle.labelMedium.copyWith(color: AppColor.primary),
              onPressed: () async {
                var response = await locator<NavigationService>().pushNamed(Routes.changePassword);
              }
          )

        ],
      ),
    );
  }

}

Widget _buildItemSection(String? key, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (key != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(key,  style: AppTextStyle.labelMedium.copyWith(color: AppColor.secondaryText),),
          ),

        Text(value,  style: AppTextStyle.bodyMedium,),

      ],
    ),
  );
}