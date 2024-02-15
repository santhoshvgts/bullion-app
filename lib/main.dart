import 'dart:async';

import 'package:bullion/router.dart';
import 'package:bullion/services/push_notification_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/device_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riskified/flutter_riskified.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/res/styles.dart';
import 'helper/dialog_manager.dart';
import 'helper/logger.dart';
import 'locator.dart';
import 'services/shared/dialog_service.dart';
import 'services/shared/navigator_service.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      setupLocator();

      await Firebase.initializeApp();
      configureLogger();

      await locator<DeviceService>().initPlatformPackageInfo();
      await Riskified.startBeacon("bullion.com", locator<DeviceService>().getRiskifiedSessionId()!, debugInfo: true);

      FlutterError.onError = (FlutterErrorDetails details) {
        Logger.e(details.toString(), s: StackTrace.current);
      };

      runApp(const MyApp());

      String devDsn = 'https://a6c53009b152945a1ba552b0752c404d@o4504257190821888.ingest.sentry.io/4506715221524480';
      String dsn = 'https://d5997437f41a06c4ca118856ab998585@o4504257190821888.ingest.sentry.io/4506715234893824';

      await SentryFlutter.init((options) async {
          options.dsn = await locator<DeviceService>().getEnvironment() == "DEVELOP"
              ? devDsn
              : dsn;
          options.debug = !kReleaseMode;
          options.tracesSampleRate = 1.0;

        },
        appRunner: () => runApp(const MyApp()),
      );
    },
    (error, stack) {
      Logger.e("Zoned Error", e: error, s: stack);
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    locator<AnalyticsService>().logEvent("Session_Start", {});
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        break;
      default:
    }
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: "Bullion",
      theme: AppStyle.appTheme,
      builder: _setupDialogManager,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: navigationService.navigatorKey,
      navigatorObservers: [
        RouteObserver(),
        AnalyticsService.observer,
      ],
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
    );
  }

  Widget _setupDialogManager(context, widget) {
    return Navigator(
      key: locator<DialogService>().dialogNavigationKey,
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) {
        final MediaQueryData data = MediaQuery.of(context);
        return DialogManager(
          child: MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: widget,
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //locator<NetworkService>().dispose();
    super.dispose();
  }
}
