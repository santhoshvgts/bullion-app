
import 'package:bullion/core/res/images.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {

  const AccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          locator<NavigationService>().pushNamed(Routes.settings);
        },
        icon: Image.asset(Images.accountIcon, width: 30,)
    );
  }

}