import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/action_button.dart';
import 'package:bullion/core/models/module/display_settings.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/router.dart';
import 'package:stacked/stacked.dart';

class ModuleUIContainerViewModel extends BaseViewModel {
  GlobalKey titleSectionKey = new GlobalKey();
  GlobalKey actionSectionKey = new GlobalKey();

  double _titleSectionHeight = 0;
  double _actionSectionHeight = 0;
  double _actionSectionWidth = 0;

  Timer? _timer;
  int? _seconds;
  String? _endTime;

  String get endTime => timeFormatter(Duration(seconds: _seconds!));

  int? get seconds => _seconds;
  Timer? get timer => _timer;

  ModuleSettings? _setting;

  ModuleSettings? get setting => _setting;

  DisplaySettings? get displaySetting => _setting!.displaySettings;

  List<ActionButton>? get actions => _setting!.actions;

  double get headSectionHeight {
    if ((displaySetting!.actionButtonsPosition.contains("bottom") || displaySetting!.actionButtonsPosition.contains("top")) && setting!.hasActionButton) {
      return _titleSectionHeight + 40;
    }
    return _titleSectionHeight;
  }

  double get titleSectionPositionLeft {
    if (displaySetting!.actionButtonsPosition == "left") {
      return _actionSectionWidth + 10;
    }
    return 0;
  }

  double get titleSectionPositionRight {
    if (displaySetting!.actionButtonsPosition == "right") {
      return _actionSectionWidth + 10;
    }
    return 0;
  }

  double get titleSectionPositionTop {
    if (displaySetting!.actionButtonsPosition.contains("top")) {
      return _actionSectionHeight + 10;
    }
    return 0;
  }

  @required
  init(ModuleSettings? setting) {
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);
    this._setting = setting;
    _setting!.hasHeaderSection ? data() : null;
    notifyListeners();
  }

  String timeFormatter(Duration duration) {
    return ["${duration.inHours.remainder(60)}", "${duration.inMinutes.remainder(60)}", "${duration.inSeconds.remainder(60)}"].map((seg) => seg.padLeft(2, '0')).join(':');
  }

  void data() {
    if (setting!.metaData?.saleEndDate != null) {
      final endDate = DateTime.parse(setting!.metaData!.saleEndDate!);
      final currentDate = DateTime.now();

      DateTime date = new DateTime(currentDate.year, currentDate.month, currentDate.day, endDate.hour, endDate.minute, endDate.second);

      if (currentDate.isAfter(date)) {
        date = date.add(Duration(days: 1));
      }
      _seconds = date.difference(currentDate).inSeconds;
      _startTimer();
    }
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_seconds! <= 0) {
          timer.cancel();
          notifyListeners();
        } else {
          _seconds = _seconds! - 1;
          notifyListeners();
        }
      },
    );
  }

  _afterLayout(_) {
    if (setting!.hasHeaderSection) {
      if (titleSectionKey.currentContext != null) {
        _titleSectionHeight = titleSectionKey.currentContext!.size!.height;
      }

      if (setting!.hasActionButton && actionSectionKey.currentContext != null) {
        _actionSectionHeight = actionSectionKey.currentContext!.size!.height;
        _actionSectionWidth = actionSectionKey.currentContext!.size!.width;
      }
      notifyListeners();
    }
  }
}
