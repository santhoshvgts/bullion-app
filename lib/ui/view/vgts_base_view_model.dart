
import 'package:bullion/core/models/api/api_error_response.dart';
import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import '../../locator.dart';
import '../../services/shared/api_base_service.dart';
import '../../services/shared/api_model/error_response_exception.dart';
import '../../services/shared/api_model/no_response_exception.dart';
import '../../services/shared/api_model/request_settings.dart';
import '../../services/shared/preference_service.dart';

class VGTSBaseViewModel extends BaseViewModel {
  final PreferenceService preferenceService = locator<PreferenceService>();
  final NavigationService navigationService = locator<NavigationService>();

  VGTSBaseViewModel() {onInit();}

  @protected
  @mustCallSuper
  Future onInit() async {
    return true;
  }

  @override
  @mustCallSuper
  void dispose() => super.dispose();

  Future<T?> request<T extends BaseModel>(RequestSettings settings) async {
    try {
      return await ApiBaseService().request(settings);
    } on ErrorResponseException catch (exception) {
      handleErrorResponse(settings, exception);
    } on NoResponseException catch (exception) {
      handleNoResponse(settings, exception);
    }

    return null;
  }

  Future<List<T>?> requestList<T extends BaseModel>(RequestSettings settings) async {
    try {
      return await ApiBaseService().requestList(settings);
    } on ErrorResponseException catch (exception) {
      handleErrorResponse(settings, exception);
    } on NoResponseException catch (exception) {
      handleNoResponse(settings, exception);
    }

    return null;
  }

  void handleNoResponse(RequestSettings settings, NoResponseException exception) {
    debugPrint(exception.message);
  }

  void handleErrorResponse(RequestSettings settings, ErrorResponseException exception) {
    ErrorResponse? error = exception.error;
    if (error != null) {
      locator<DialogService>().showDialog(title: 'Error', description: error.getSingleMessage());
    }
  }

  void handleException() => debugPrint("HANDLE EXCEPTION");
}
