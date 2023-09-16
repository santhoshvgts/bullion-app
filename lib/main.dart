import 'dart:async';
import 'dart:io';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/device_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/shared/dialog_service.dart';
import 'services/shared/navigator_service.dart';
import 'core/res/styles.dart';
import 'helper/dialog_manager.dart';
import 'helper/logger.dart';
import 'locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupLocator();

    await Firebase.initializeApp();
    configureLogger();

    await locator<DeviceService>().initPlatformPackageInfo();

    FlutterError.onError = (FlutterErrorDetails details) {
      Logger.e(details.toString(), s: StackTrace.current);
    };

    runApp(const MyApp());
  }, (error, stack) {
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Platform.isIOS ? Brightness.light : Brightness.dark));

    return MaterialApp(
      title: "Bullion",
      theme: AppStyle.appTheme,
      builder: _setupDialogManager,
      initialRoute: '/',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
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
