import 'dart:async';

import 'package:bullion/ui/view/vgts_base_view_model.dart';

class CkeckOutPageViewModel extends VGTSBaseViewModel {
  @override
  onInit() {
    startTimer();
    return super.onInit();
  }

  Timer? timer;
  int _start = 599;

  int get minutes => _start ~/ 60;
  int get seconds => _start % 60;

  String get formattedSeconds {
    // Use a ternary operator to add a leading zero if the seconds is less than 10
    return seconds < 10 ? '0$seconds' : '$seconds';
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          notifyListeners();
        } else {
          _start--;
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
