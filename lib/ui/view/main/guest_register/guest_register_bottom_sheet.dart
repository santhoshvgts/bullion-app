
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/view/main/guest_register/guest_register_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuestRegisterBottomSheet extends VGTSBuilderWidget<GuestRegisterViewModel> {
  const GuestRegisterBottomSheet({super.key});

  @override
  GuestRegisterViewModel viewModelBuilder(BuildContext context) => GuestRegisterViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, GuestRegisterViewModel viewModel, Widget? child) {
    return Wrap(
      children: [

        TapOutsideUnFocus(
          child: Container(
            color: AppColor.white,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Form(
              key: viewModel.formKey,
              child: Stack(
                children: [

                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text("Email Address", style: AppTextStyle.bodySmall),

                        Text("${locator<AuthenticationService>().getUser!.email}", style: AppTextStyle.titleMedium),

                        VerticalSpacing.d20px(),

                        EditTextField.password(
                          "Set Password",
                          viewModel.passwordController,
                        ),

                        VerticalSpacing.d15px(),

                        InkWell(
                          onTap: (){
                            viewModel.rememberCheck = !viewModel.rememberCheck;
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: SizedBox(
                                    width: 20,
                                    height: 15,
                                    child: Checkbox(value: viewModel.rememberCheck, onChanged: (value){
                                    },
                                      activeColor: AppColor.primary,
                                    )
                                ),
                              ),

                              HorizontalSpacing.d10px(),

                              const Expanded(child: Text(" I also want to receive Precious Metal news, special offers and information from Bullion.com by email.",  style: AppTextStyle.bodySmall,),)

                            ],
                          ),
                        ),

                        VerticalSpacing.d15px(),

                        Button("Register", width: double.infinity,
                          onPressed: (){
                            viewModel.register();
                          }, valueKey: const Key("BtnReg"),),

                        VerticalSpacing.d15px(),

                      ],
                    ),
                  ),

                  if (viewModel.isBusy)
                    Container(
                      color: AppColor.white.withOpacity(0.7),
                      height: MediaQuery.of(context).size.height / 2.7,
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
            ),
          ),
        ),

      ],

    );
  }

}