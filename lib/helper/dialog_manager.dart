// ignore_for_file: library_private_types_in_public_api

import 'package:bullion/core/models/alert/alert_request.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogManager extends StatefulWidget {
  final Widget? child;

  const DialogManager({Key? key, this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showInfoDialog);
    _dialogService.registerConfirmDialogListener(_showConfirmationDialog);
    _dialogService.registerBottomSheetListener(_bottomSheet);
    _dialogService.registerDisplayMessageListener(_showDisplayMessageDialog);
    _dialogService.registerDrawerListener(_showCustomDrawer);
    _dialogService.registerLoaderListener(_showCustomLoader);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Dialog Manager being built");

    return widget.child!;
  }

  _showInfoDialog(AlertRequest request) {
    showDialog(
      useRootNavigator: true,
      context: context,

      builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              _dialogService.dialogComplete(AlertResponse(status: false));
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              ),
              actionsPadding: const EdgeInsets.only(bottom: 10, right: 20),
              title: Text(
                request.title!,
                
                style: AppTextStyle.bodyMedium,
              ),
              content: Text(request.description!, style: AppTextStyle.bodyMedium),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "OK",
                    
                    style: AppTextStyle.labelMedium,
                  ),
                  onPressed: () {
                    _dialogService.dialogComplete(AlertResponse(status: true));
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  _showConfirmationDialog(AlertRequest request) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async {
              _dialogService.dialogComplete(AlertResponse(status: false));
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              actionsPadding: const EdgeInsets.only(bottom: 10, right: 20),
              title: Text(
                request.title!,
                
                style: AppTextStyle.titleMedium.copyWith(color: AppColor.primary),
              ),
              content: Text(request.description!,  style: AppTextStyle.bodyMedium),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Cancel",
                    
                    style: AppTextStyle.labelMedium,
                  ),
                  onPressed: () {
                    _dialogService.dialogComplete(AlertResponse(status: false));
                  },
                ),
                TextButton(
                  child: Text(
                    request.buttonTitle!,
                    
                    style: AppTextStyle.labelMedium,
                  ),
                  onPressed: () {
                    _dialogService.dialogComplete(AlertResponse(status: true));
                  },
                ),
              ],
            ),
          );
    });
  }

  void _bottomSheet(AlertRequest request) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: request.enableDrag!,
        isDismissible: request.isDismissible!,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.bottom > 0 ? MediaQuery.of(context).viewPadding.bottom : 25),
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Wrap(
                children: [
                  if (request.showActionBar!)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (request.iconWidget != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: request.iconWidget,
                            ),
                          Expanded(
                              child: request.title == null
                                  ? Container()
                                  : Container(
                                      alignment: request.headerAlignment,
                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: Text(
                                        request.title!,
                                        
                                        style: AppTextStyle.titleLarge.copyWith(
                                          fontSize: 17,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                          if (request.showCloseIcon!)
                            IconButton(
                              onPressed: () {
                                _dialogService.dialogComplete(AlertResponse(status: null));
                              },
                              icon: Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.secondaryBackground, boxShadow: AppStyle.mildCardShadow),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppColor.title,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (request.showDivider!)
                    if (request.showActionBar!)
                      if (request.title != null) AppStyle.customDivider,
                  SingleChildScrollView(
                      child: Wrap(
                    children: [
                      request.contentWidget!,
                    ],
                  )),
                ],
              ),
            ));
  }

  void _showCustomDrawer(AlertRequest request) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          const begin = Offset(1.0, 0.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return Align(
              alignment: Alignment.centerRight, // Align to the right
              child: SlideTransition(
                  position: animation.drive(tween),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.75, // 30% of screen width
                      color: AppColor.scaffoldBackground,
                      child: request.contentWidget)));
        });
  }

  void _showCustomLoader(AlertRequest request) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColor.white.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return Center(
          child: Stack(
            children: [
              const Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Image.asset(
                    Images.appBullLogo,
                    width: 50,
                    height: 50,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showDisplayMessageDialog(AlertRequest request) {
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              _dialogService.dialogComplete(AlertResponse(status: false));
              return false;
            },
            child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Wrap(
                  children: [
                    if (request.showActionBar!)
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (request.iconWidget != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: request.iconWidget,
                              ),
                            Expanded(
                                child: request.title == null
                                    ? Container()
                                    : Text(
                                        request.title!,
                                        
                                        style: AppTextStyle.titleLarge.copyWith(
                                          fontSize: 17,
                                        ),
                                      )),
                            IconButton(
                              onPressed: () {
                                _dialogService.dialogComplete(AlertResponse());
                              },
                              icon: Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.secondaryBackground, boxShadow: AppStyle.mildCardShadow),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppColor.title,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    request.contentWidget!
                  ],
                )),
          );
        });
  }
}
