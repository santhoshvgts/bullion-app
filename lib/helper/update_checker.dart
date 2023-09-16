class UpdateChecker {
  versionCheck() async {
  //   final PackageInfo info = await PackageInfo.fromPlatform();
  //   final String currentVersion = info.version;
  //
  //   final AppConfig? appConfig = locator<AppConfigService>().config;
  //
  //   final AppStoreLink appStore = Platform.isIOS ? appConfig.appStoreLinks!.iosStore! : appConfig.appStoreLinks!.androidStore!;
  //
  //   try {
  //     print("appStore.version: ${appStore.version}");
  //     print("current.version: $currentVersion");
  //
  //     if (int.parse(appStore.version!.replaceAll(".", "")) > int.parse(currentVersion.replaceAll(".", ""))) {
  //       String message = appStore.updateMessage ?? 'New  Update Available';
  //
  //       locator<AnalyticsService>().logScreenName("update_dialog");
  //       locator<AnalyticsService>().logEvent("update_dialog", <String, dynamic>{'version': appStore.version, 'message': message});
  //
  //       if (appStore.fullPageDialog == false) {
  //         return dialogService.showBottomSheet(
  //             showCloseIcon: (appStore.forceUpdate ?? true) == true ? false : true,
  //             dismissable: (appStore.forceUpdate ?? true) == true ? false : true,
  //             child: Container(
  //               color: Colors.white,
  //               padding: const EdgeInsets.all(20),
  //               width: double.infinity,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Image.asset(
  //                     Images.app_update,
  //                     width: 225,
  //                   ),
  //                   if (appStore.title?.isNotEmpty == true)
  //                     Text(
  //                       appStore.title ?? '',
  //                       style: AppTextStyle.subHeadingSemiBold,
  //                     ),
  //                   VerticalSpacing.d10px(),
  //                   CustomHtmlWidget(
  //                     appStore.updateMessage ?? '',
  //                     textStyle: AppTextStyle.bodyMedium,
  //                   ),
  //                   VerticalSpacing.d30px(),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: Button("Update Now", key: const ValueKey("btnUpdate"), onPressed: () async {
  //                       await launchUrl(
  //                         Uri.parse(appStore.url!),
  //                         mode: LaunchMode.externalApplication,
  //                       );
  //                     }),
  //                   )
  //                 ],
  //               ),
  //             ));
  //       }
  //
  //       return navigationService.push(Scaffold(
  //         appBar: AppBar(
  //           automaticallyImplyLeading: false,
  //           actions: [
  //             if ((appStore.forceUpdate ?? true) == false)
  //               IconButton(
  //                 onPressed: () {
  //                   navigationService.pop();
  //                 },
  //                 icon: Container(
  //                   decoration: const BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: Colors.black12,
  //                   ),
  //                   padding: const EdgeInsets.all(5),
  //                   child: const Icon(
  //                     Icons.close,
  //                     size: 20,
  //                     color: Colors.black54,
  //                   ),
  //                 ),
  //               )
  //           ],
  //         ),
  //         body: WillPopScope(
  //             child: SafeArea(
  //               child: Container(
  //                 color: Colors.white,
  //                 padding: const EdgeInsets.all(20),
  //                 width: double.infinity,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Flexible(
  //                         child: Center(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Image.asset(
  //                             Images.app_update,
  //                             width: 225,
  //                           ),
  //                           VerticalSpacing.d10px(),
  //                           if (appStore.title?.isNotEmpty == true)
  //                             Text(
  //                               appStore.title ?? '',
  //                               style: AppTextStyle.subHeadingSemiBold,
  //                             ),
  //                           VerticalSpacing.d10px(),
  //                           CustomHtmlWidget(
  //                             appStore.updateMessage ?? '',
  //                             textStyle: AppTextStyle.bodyMedium,
  //                           ),
  //                         ],
  //                       ),
  //                     )),
  //                     VerticalSpacing.d30px(),
  //                     SizedBox(
  //                       width: double.infinity,
  //                       child: Button("Update Now", key: const ValueKey("btnUpdate"), onPressed: () async {
  //                         await launchUrl(Uri.parse(appStore.url!),mode: LaunchMode.externalApplication,);
  //                       }),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             onWillPop: () {
  //               return Future.value(false);
  //             }),
  //       ));
  //     }
  //   } catch (exception, stacktrace) {
  //     Logger.e("Unable to check for version info", e: exception, s: stacktrace);
  //   }
  // }
  }
}
