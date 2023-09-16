import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../../../../helper/phone_number_linkifier.dart';
import 'forgot_password_view_model.dart';

class ForgotPasswordPage extends VGTSBuilderWidget<ForgotPasswordViewModel> {
  final bool fromMain;

  ForgotPasswordPage({this.fromMain = true});

  @override
  void onViewModelReady(ForgotPasswordViewModel viewModel) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    viewModel.init(fromMain);
    super.onViewModelReady(viewModel);
  }


  @override
  ForgotPasswordViewModel viewModelBuilder(BuildContext context) => ForgotPasswordViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ForgotPasswordViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              viewModel.navigationService!.pop(returnValue: false);
            }),
      ),
      body: SafeArea(
        child: TapOutsideUnFocus(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  Images.appLogo,
                  height: 40.0,
                ),
              ),

              const Padding(padding: EdgeInsets.only(top: 35)),

              const Text(
                "Forgot Password",
                textScaleFactor: 1,
                style: AppTextStyle.header,
              ),

              const Padding(padding: EdgeInsets.only(top: 10)),

              Linkify(
                onOpen: (link) async {
                  launchUrl(link.url);
                },
                linkifiers: const [
                  PhoneNumberLinkifier(),
                  EmailLinkifier(),
                  UrlLinkifier()
                ],
                text: "Enter the email address associated with your account and we'll email you a secure link to reset your password. If you do not receive an email, please try resubmitting your request or contacting customer service at service@APMEX.com for assistance.",
                style: AppTextStyle.body,
                linkStyle: AppTextStyle.body.copyWith(color: Colors.blue),
              ),

              EditTextField(
                "Email Address",
                viewModel.emailController,
                margin: const EdgeInsets.only(top: 30),
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                onChanged: (value) {

                },
              ),

              const Padding(padding: EdgeInsets.only(top: 20)),

              Button(
                "Submit",
                valueKey: const Key("btnSubmit"),
                loading: viewModel.isBusy,
                disabled: viewModel.emailController.text.isEmpty,
                onPressed: () => viewModel.submit(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
