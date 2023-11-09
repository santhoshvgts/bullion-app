import 'dart:async';

import 'package:bullion/core/models/alert/alert_request.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:flutter/material.dart';

class DialogService {
  final _dialogNavigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;
  late Function(AlertRequest) _showDialogListener;
  late Function(AlertRequest) _showConfirmDialogListener;

  final Map<ValueKey, Completer<AlertResponse>?> _dialogCompleterMap = {};

  late Function(AlertRequest) _bottomSheetListener;
  late Function(AlertRequest) _drawerListerner;
  late Function(AlertRequest) _loaderListerner;
  late Function(AlertRequest) _displayMessageListener;

  void registerDialogListener(Function(AlertRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  void registerConfirmDialogListener(
      Function(AlertRequest) showConfirmDialogListener) {
    _showConfirmDialogListener = showConfirmDialogListener;
  }

  void registerBottomSheetListener(Function(AlertRequest) bottomSheetListener) {
    _bottomSheetListener = bottomSheetListener;
  }

  void registerDrawerListener(Function(AlertRequest) drawerListerner) {
    _drawerListerner = drawerListerner;
  }

  void registerLoaderListener(Function(AlertRequest) loaderListerner) {
    _loaderListerner = loaderListerner;
  }

  void registerDisplayMessageListener(
      Function(AlertRequest) displayMessageListener) {
    _displayMessageListener = displayMessageListener;
  }

  Future<AlertResponse> showDrawer(
      {ValueKey key = const ValueKey("defaultDialogKey"), Widget? child}) {
    _dialogCompleterMap[key] = Completer<AlertResponse>();
    _drawerListerner(AlertRequest(contentWidget: child));
    return _dialogCompleterMap[key]!.future;
  }

  Future<AlertResponse> showLoader(
      {ValueKey key = const ValueKey("defaultDialogKey"), bool? isBusy}) {
    _dialogCompleterMap[key] = Completer<AlertResponse>();
    _loaderListerner(AlertRequest(isDismissible: isBusy));
    return _dialogCompleterMap[key]!.future;
  }


  Future<AlertResponse> showDialog(
      {ValueKey key = const ValueKey("defaultDialogKey"),
      String title = 'Message',
      String? description,
      String buttonTitle = 'OK'}) {
    _dialogCompleterMap[key] = Completer<AlertResponse>();
    _showDialogListener(AlertRequest(
        description: description, buttonTitle: buttonTitle, title: title));
    return _dialogCompleterMap[key]!.future;
  }

  Future<AlertResponse> showConfirmationDialog(
      {ValueKey key = const ValueKey("defaultDialogKey"),
      String? title = "Message",
      String? description,
      String? buttonTitle = 'OK'}) {
    _dialogCompleterMap[key] = Completer<AlertResponse>();
    _showConfirmDialogListener(AlertRequest(
        description: description,
        buttonTitle: buttonTitle ?? 'Confirm',
        title: title));

    return _dialogCompleterMap[key]!.future;
  }

  Future<AlertResponse> showBottomSheet({
    ValueKey key = const ValueKey("defaultDialogKey"),
    String? title,
    Widget? iconWidget,
    Widget? child,
    bool showActionBar = true,
    bool isDismissible = true,
    bool showCloseIcon = true,
    bool enableDrag = true,
    bool showDivider = true,
    Alignment? headerAlignment,
  }) {
    _dialogCompleterMap[key] = Completer<AlertResponse>();
    _bottomSheetListener(
      AlertRequest(
        title: title,
        iconWidget: iconWidget,
        contentWidget: child,
        showActionBar: showActionBar,
        showCloseIcon: showCloseIcon,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        showDivider: showDivider,
        headerAlignment: headerAlignment,
      ),
    );

    return _dialogCompleterMap[key]!.future;
  }

  Future<AlertResponse> displayMessage(
      {ValueKey key = const ValueKey("defaultDialogKey"),
      String? title,
      Widget? iconWidget,
      Widget? child,
      bool showActionBar = true}) {
    _dialogCompleterMap[key] = Completer<AlertResponse>();
    _displayMessageListener(AlertRequest(
        title: title,
        iconWidget: iconWidget,
        contentWidget: child,
        showActionBar: showActionBar));
    return _dialogCompleterMap[key]!.future;
  }

  void dialogComplete(AlertResponse? alertResponse,
      {ValueKey key = const ValueKey("defaultDialogKey")}) {
    if (_dialogCompleterMap[key] == null) {
      _dialogNavigationKey.currentState!.pop(alertResponse);
      return;
    }

    _dialogCompleterMap[key]!.complete(alertResponse);
    _dialogNavigationKey.currentState!.pop(alertResponse);
    _dialogCompleterMap[key] = null;
  }

  void dialogMaybeComplete(AlertResponse? alertResponse,
      {ValueKey key = const ValueKey("defaultDialogKey")}) {
    if (_dialogCompleterMap[key] == null) {
      _dialogNavigationKey.currentState!.maybePop(alertResponse);
      return;
    }

    _dialogCompleterMap[key]!.complete(alertResponse);
    _dialogNavigationKey.currentState!.maybePop(alertResponse);
    _dialogCompleterMap[key] = null;
  }
}
