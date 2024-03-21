import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/phone_number_linkifier.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class DisplayMessageToast extends StatelessWidget {
  final DisplayMessage displayMessage;

  const DisplayMessageToast(this.displayMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 60, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppStyle.cardShadow,
          border: Border.all(color: displayMessage.color),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Row(
                children: [

                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        displayMessage.icon,
                        color: displayMessage.color,
                        size: 35,
                      )
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        if (displayMessage.title != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Text(displayMessage.title ?? '',
                                style: AppTextStyle.titleMedium.copyWith(color: displayMessage.textColor),
                                textAlign: TextAlign.start
                            ),
                          ),
                        if (displayMessage.subText != null)
                          Text(displayMessage.subText ?? '',
                              style: AppTextStyle.titleSmall,
                              textAlign: TextAlign.start
                          ),

                      ],
                    ),
                  )

                ],
              ),

              Container(
                decoration: const BoxDecoration(color: Colors.white12,),
                padding: const EdgeInsets.all(10),
                child: Text(
                  displayMessage.message ?? '',
                  style: AppTextStyle.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayMessageBottomSheet extends StatelessWidget {
  final DisplayMessage? _displayMessage;

  DisplayMessageBottomSheet(this._displayMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Row(
              children: [

                CircleAvatar(
                  backgroundColor: _displayMessage?.color,
                  child: Icon(_displayMessage?.icon, color: Colors.white,),
                ),

                HorizontalSpacing.d10px(),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        _displayMessage!.title!,
                        style: AppTextStyle.titleMedium.copyWith(color: _displayMessage!.color),
                      ),

                      if (_displayMessage?.subText != null)
                        Text(
                          _displayMessage?.subText ?? "",
                          style: AppTextStyle.titleSmall,
                        ),

                    ],
                  ),
                )

              ],
            ),

            VerticalSpacing.d10px(),

            Text(
              _displayMessage!.message!,
              style: AppTextStyle.bodyMedium,
            ),

            VerticalSpacing.d20px(),

            Button.outline("Close",
              width: double.infinity,
              borderColor: AppColor.primary,
              textStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary),
              valueKey: const ValueKey("btnClose"),
              onPressed: () {
                locator<DialogService>().dialogComplete(AlertResponse(status: true));
              }
            )

          ],
        ),
      ),
    );
  }
}
