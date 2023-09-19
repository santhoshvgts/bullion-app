import 'package:flutter/material.dart';
import 'package:bullion/core/models/alert/alert_request.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget? child;

  const DialogManager({Key? key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService? _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService!.registerDialogListener(_showInfoDialog);
    _dialogService!.registerConfirmDialogListener(_showConfirmationDialog);
    _dialogService!.registerBottomSheetListener(_bottomSheet);
    _dialogService!.registerDisplayMessageListener(_showDisplayMessageDialog);
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
              _dialogService!.dialogComplete(AlertResponse(status: false));
              return false;
            },
            child: AlertDialog(
              title: Text(
                request.title!,
                textScaleFactor: 1,
                style: AppTextStyle.dialogButtonOutline,
              ),
              content: Text(request.description!, style: AppTextStyle.body),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "OK",
                    textScaleFactor: 1,
                    style: AppTextStyle.dialogButton,
                  ),
                  onPressed: () {
                    _dialogService!.dialogComplete(AlertResponse(status: true));
                  },
                ),
              ],
            ),
          );
        });
  }

  _showConfirmationDialog(AlertRequest request) {
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              _dialogService!.dialogComplete(AlertResponse(status: false));
              return false;
            },
            child: AlertDialog(
              title: Text(
                request.title!,
                textScaleFactor: 1,
                style: AppTextStyle.appBarTitle.copyWith(color: AppColor.primary),
              ),
              content: Text(request.description!, textScaleFactor: 1, style: AppTextStyle.text),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Cancel",
                    textScaleFactor: 1,
                    style: AppTextStyle.dialogButton,
                  ),
                  onPressed: () {
                    _dialogService!.dialogComplete(AlertResponse(status: false));
                  },
                ),
                TextButton(
                  child: Text(
                    request.buttonTitle!,
                    textScaleFactor: 1,
                    style: AppTextStyle.dialogButton,
                  ),
                  onPressed: () {
                    _dialogService!.dialogComplete(AlertResponse(status: true));
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
              decoration: BoxDecoration(
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
                              padding: EdgeInsets.only(right: 10),
                              child: request.iconWidget,
                            ),
                          Expanded(
                              child: request.title == null
                                  ? Container()
                                  : Container(
                                      alignment: request.headerAlignment,
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Text(
                                        request.title!,
                                        textScaleFactor: 1,
                                        style: AppTextStyle.title.copyWith(
                                          fontSize: 17,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                          if (request.showCloseIcon!)
                            IconButton(
                              onPressed: () {
                                _dialogService!.dialogComplete(AlertResponse(status: null));
                              },
                              icon: Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.secondaryBackground, boxShadow: AppStyle.mildCardShadow),
                                padding: EdgeInsets.all(5),
                                child: Icon(
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

    // showModalBottomSheet(
    //      context: context,
    //      dismissOnTap: false,
    //      resizeToAvoidBottomPadding: true,
    //      statusBarHeight: MediaQuery.of(context).padding.top ,
    //      builder: (context) =>
    //  );
  }

  void _showDisplayMessageDialog(AlertRequest request) {
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              _dialogService!.dialogComplete(AlertResponse(status: false));
              return false;
            },
            child: Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                padding: EdgeInsets.only(right: 10),
                                child: request.iconWidget,
                              ),
                            Expanded(
                                child: request.title == null
                                    ? Container()
                                    : Text(
                                        request.title!,
                                        textScaleFactor: 1,
                                        style: AppTextStyle.title.copyWith(
                                          fontSize: 17,
                                        ),
                                      )),
                            IconButton(
                              onPressed: () {
                                _dialogService!.dialogComplete(AlertResponse());
                              },
                              icon: Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.secondaryBackground, boxShadow: AppStyle.mildCardShadow),
                                padding: EdgeInsets.all(5),
                                child: Icon(
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
