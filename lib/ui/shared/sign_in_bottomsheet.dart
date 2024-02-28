import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import '../../../../locator.dart';

enum SignInBottomSheetResult { LOGIN, REGISTER, GUEST }

class SignInBottomSheet extends StatelessWidget {

  String image;
  String? title;
  String? content;
  bool showGuestLogin;

  SignInBottomSheet(this.image, {this.title, this.content, this.showGuestLogin = false});

  @override
  Widget build(BuildContext context) {

    return Wrap(
      children: [

        Container(
          color: AppColor.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [

                if (content!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(content!, style: AppTextStyle.titleSmall, textAlign: TextAlign.center,),
                  ),

                VerticalSpacing.d20px(),

                _Button(),

                if (showGuestLogin)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    child: MaterialButton(
                      key: const Key('btnCreateAccount'),
                      onPressed: (){
                        locator<DialogService>().dialogComplete(AlertResponse(status: true, data: SignInBottomSheetResult.GUEST));
                      },
                      child: Text("Continue as Guest", style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary, decoration: TextDecoration.underline), textAlign: TextAlign.center,),),
                  ),

                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
                //   child: Text(" Proceed to checkout and you will have an opportunity to create an account at the end if one does not already exist for you.", style: AppTextStyle.bodyMedium, textAlign: TextAlign.center,),
                // ),

              ],
            ),
          ),
        ),
      ],
    );
  }

}

class _Button extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
   return Container(
     padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
     child: Column(
       children: [

         Button(
           "Sign In",
             valueKey: const Key('btnSignIn'),
           width:double.infinity,
           textStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.white),
           color: AppColor.primary,
           onPressed: () async {
             locator<DialogService>().dialogComplete(AlertResponse(status: true, data: SignInBottomSheetResult.LOGIN));
           }
         ),

         VerticalSpacing.d10px(),

         Button.outline(
             "Create Account",
             valueKey: const Key('btnCreateAccount'),
             width: double.infinity,
             textStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary),
             borderColor: AppColor.primary,
             onPressed: (){
               locator<DialogService>().dialogComplete(AlertResponse(status: true, data: SignInBottomSheetResult.REGISTER));
             }
         )
       ],
     ),
   );
  }

}