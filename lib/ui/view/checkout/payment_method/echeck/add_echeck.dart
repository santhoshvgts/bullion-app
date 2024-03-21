import 'package:flutter/material.dart';
import 'package:bullion/core/enums/echeck_type.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/button.dart';

import '../../../../../../locator.dart';

class AddECheckBottomSheet extends StatelessWidget {

  bool? allowManualACH;
  bool? allowPlaidACH;

  AddECheckBottomSheet({ this.allowPlaidACH, this.allowManualACH });

  @override
  Widget build(BuildContext context,) {

    print(allowPlaidACH);

    return SafeArea(
      child: Column(
        children: [

          if (allowPlaidACH!)
            _VerifyOnlineBanking(),

          if (allowPlaidACH!)
          VerticalSpacing.d10px(),

          if (allowManualACH! && allowPlaidACH!)
            Container(height: 1, child: AppStyle.customDivider),

          if (allowManualACH!)
            _BankInfo(),

        ],
      ),
    );
  }

}


class _VerifyOnlineBanking extends StatelessWidget {

  List<String> verifyOnlineBanking = [ "Login with your online banking information to get instantly verified.",
    "After completing a one-time verification process, your payment is processed same or next business day.",
    "This payment qualifies for a cash discount."
  ];

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify via Online Banking (ACH)",style: AppTextStyle.titleMedium,),

          VerticalSpacing.d15px(),

          ...verifyOnlineBanking.map((e) {
            return _Points(e);
          }) .toList(),

          VerticalSpacing.d10px(),

          Button("Verify your Bank Account".toUpperCase(),
              width: double.infinity,
              valueKey: Key("BtnVerifyAcc"),
              onPressed: () {
                locator<DialogService>().dialogComplete(AlertResponse(data: eCheckType.Plaid));
              }
          ),

        ],
      ),

    );


  }

}

class _BankInfo extends StatelessWidget {

  List<String> bankInfo = [ "Manually enter your routing and account number to verify your payment.",
    "After completing a one-time verification process, your payment is processed same or next business day.",
    "This payment qualifies for a cash discount."
  ];

  @override
  Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 10.0,bottom:20.0,left: 20.0,right: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text("Enter Bank Information",style: AppTextStyle.titleMedium,),

        VerticalSpacing.d15px(),

        ...bankInfo.map((e) {
          return _Points(e);
        }) .toList(),

        VerticalSpacing.d10px(),


        Button.outline("Enter Your Bank Information".toUpperCase(),
          width: double.infinity,
          valueKey: Key("BtnBankInfo"),
          onPressed: () {
            locator<DialogService>().dialogComplete(AlertResponse(data: eCheckType.Manual));
          }
        ),

      ],
    ),
  );

  }

}

class _Points extends StatelessWidget {

  final String points;
  _Points(this.points);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: AppColor.text,
            ),
          ),

          HorizontalSpacing.d10px(),

          Expanded(child: Text(points,style: AppTextStyle.bodyMedium,))

        ],
      ),
    );

  }

}