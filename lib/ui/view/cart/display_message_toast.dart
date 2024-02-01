import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/phone_number_linkifier.dart';
import 'package:bullion/helper/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class DisplayMessageToast extends StatelessWidget {
  final DisplayMessage _displayMessage;

  DisplayMessageToast(this._displayMessage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
      decoration:
          BoxDecoration(color: AppColor.white, boxShadow: AppStyle.cardShadow),
      child: Row(
        children: [
          // IconType(_displayMessage.messageType),

          HorizontalSpacing.d10px(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _displayMessage.message!,
                  
                  style: AppTextStyle.bodyLarge.copyWith(
                      color: AppColor.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayMessageBottomSheet extends StatelessWidget {
  final DisplayMessage? _displayMessage;

  DisplayMessageBottomSheet(this._displayMessage);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColor.secondaryBackground,
                  border: Border(
                      left:
                          BorderSide(color: _displayMessage!.color, width: 2))),
              padding: EdgeInsets.all(10),
              child: Text(
                _displayMessage!.message!,
                
                style: AppTextStyle.bodyLarge
                    .copyWith(color: _displayMessage!.textColor),
              ),
            ),
            if (_displayMessage!.subText != null)
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Linkify(
                    onOpen: (link) async {
                      launchAnUrl(link.url);
                    },
                    linkifiers: [
                      PhoneNumberLinkifier(),
                      EmailLinkifier(),
                      UrlLinkifier()
                    ],
                    text: _displayMessage!.subText!,
                    style: AppTextStyle.bodyMedium,
                    linkStyle:
                        AppTextStyle.bodyMedium.copyWith(color: Colors.blue),
                  )
                  // child: Text(_displayMessage.subText,  textAlign: TextAlign.left, style: AppTextStyle.body),
                  ),
          ],
        ),
      ),
    );
  }
}
