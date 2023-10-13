import 'package:bullion/ui/view/core/page_middleware_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageMiddleware extends VGTSBuilderWidget<PageMiddlewareViewModel> {
  final String? url;
  final dynamic argument;

  const PageMiddleware(this.url, this.argument);

  @override
  PageMiddlewareViewModel viewModelBuilder(BuildContext context) =>
      PageMiddlewareViewModel(this.url, this.argument);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      PageMiddlewareViewModel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: const Opacity(
        opacity: 0.0,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 100,
              //   width: 100,
              //   child: CircularProgressIndicator(
              //     strokeWidth: 2,
              //     valueColor: AlwaysStoppedAnimation(AppColor.primary),
              //   ),
              // ),
              //
              // VerticalSpacing.d15px(),
              //
              // Center(child: Text("Redirecting", textScaleFactor: 1, style: AppTextStyle.labelMedium,))
            ],
          ),
        ),
      ),
    );
  }
}
