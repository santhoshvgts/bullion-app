
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordSuccessPage extends StatelessWidget {

  String? message;

  ForgotPasswordSuccessPage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions:[ IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              locator<NavigationService>().pop(returnValue: false);
            }),
        ]
      ),
      body: SafeArea(
        child: TapOutsideUnFocus(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                const Text("Reset Password Link Sent \nSuccessfully !", textScaleFactor: 1, textAlign: TextAlign.center, style: AppTextStyle.title,),

                VerticalSpacing.d20px(),

                const Icon(Icons.check_circle, color: AppColor.offerText, size: 100,),

                VerticalSpacing.d10px(),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: ApmexHtmlWidget(
                    message,
                    textStyle: AppTextStyle.text.copyWith(height:1.8,)
                  ),
                  // child: Text(parse(message).outerHtml, textAlign: TextAlign.center, style: AppTextStyle.text.copyWith(height:1.8,), ),
                ),

                // Button("Next", valueKey: Key("btnNext"), onPressed: (){
                //   locator<NavigationService>().pushNamed(Routes.resetPassword);
                // })

              ],
            ),
          ),
        ),
      ),
    );
  }

}