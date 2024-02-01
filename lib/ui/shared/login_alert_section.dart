
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';

class LoginAlertSection extends StatelessWidget {

  const LoginAlertSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Sign In",
                  
                  style: AppTextStyle.titleMedium.copyWith(
                    color: AppColor.white,
                  ),
                ),

                VerticalSpacing.d5px(),

                Text(
                  "Authenticate using information to do more with your account",
                  
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
          // Button(
          //   "Sign In",
          //   width: 90,
          //   height: 30,
          //   textStyle: AppTextStyle.bodySmall.copyWith(
          //     color: AppColor.white,
          //   ),
          //   valueKey: const ValueKey("btnSignIn"),
          //   onPressed: () {
          //     locator<NavigationService>().pushNamed(
          //       Routes.login,
          //       arguments: { "fromMain": false },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

}