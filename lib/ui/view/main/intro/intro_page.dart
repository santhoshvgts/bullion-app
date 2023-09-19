import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/main/intro/intro_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroPage extends VGTSBuilderWidget<IntroViewModel> {
  @override
  Widget viewBuilder(BuildContext context, locale, IntroViewModel viewModel, Widget? child) {
    return Scaffold(
      bottomNavigationBar: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Button("Login", width: double.infinity, valueKey: const ValueKey("btnLogin"), onPressed: () {
              locator<NavigationService>().popAllAndPushNamed(Routes.login);
            }),
          )
        ],
      ),
    );
  }

  @override
  IntroViewModel viewModelBuilder(BuildContext context) {
    return IntroViewModel();
  }
}
