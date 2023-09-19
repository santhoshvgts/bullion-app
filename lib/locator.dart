import 'package:bullion/helper/firebase_remote_helper.dart';
import 'package:bullion/helper/update_checker.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:bullion/services/shared/device_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/shared/preference_service.dart';
import 'package:bullion/services/toast_service.dart';
import 'package:bullion/services/token_service.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'services/page_storage_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseRemoteHelper());
  locator.registerLazySingleton(() => AppConfigService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => PreferenceService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => EventBusService());

  locator.registerLazySingleton(() => ThemeService());
  locator.registerLazySingleton(() => ApiBaseService());
  locator.registerLazySingleton(() => TokenService());
  locator.registerLazySingleton(() => AuthenticationService());

  // locator.registerLazySingleton(() => AuthRepo());
  locator.registerLazySingleton(() => UpdateChecker());
  locator.registerLazySingleton(() => PageStorageService());
  // locator.registerLazySingleton(() => PushNotificationService());
  // locator.registerLazySingleton(() => LogService());
  locator.registerLazySingleton(() => ToastService());
  locator.registerLazySingleton(() => DeviceService());
  // locator.registerLazySingleton(() => LocalAuthService());
  // locator.registerLazySingleton(() => NetworkService());
}
