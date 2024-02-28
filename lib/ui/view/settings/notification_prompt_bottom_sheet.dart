
// import 'package:app_settings/app_settings.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPromptBottomSheet extends StatelessWidget {

  final String title;
  final String description;

  NotificationPromptBottomSheet(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [

        Container(
          color: AppColor.white,
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [

                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Image.asset(Images.iconEmptyNotification, height: 80, width: 80, fit: BoxFit.contain,),

                      VerticalSpacing.d30px(),

                      Text(title, textScaleFactor: 1, style: AppTextStyle.titleMedium, textAlign: TextAlign.center,),

                      VerticalSpacing.d15px(),

                      Text(description, textScaleFactor: 1, style: AppTextStyle.bodyMedium, textAlign: TextAlign.center,),

                    ],
                  ),
                ),

                VerticalSpacing.d20px(),

                Button(
                    "Turn On",
                    valueKey: const Key('btnTurnOn'),
                    width:double.infinity,
                    onPressed: () async {
                      // // AppSettings.openNotificationSettings();
                      // openAppSettings();
                      bool result = await OneSignal.Notifications.requestPermission(true);
                      locator<DialogService>().dialogComplete(AlertResponse(status: result));
                    }
                ),


              ],
            ),
          ),
        ),


      ],
    );
  }

}