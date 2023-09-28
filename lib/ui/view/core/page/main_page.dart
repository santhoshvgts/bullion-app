import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bullion/core/res/colors.dart';

class MainPage extends StatefulWidget {
  final String? path;

  MainPage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ContentWrapperController controller = ContentWrapperController();
  String? title = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBackground,
      appBar: AppBar(
       centerTitle: true,
        elevation: 1,
        titleSpacing: 0,
        title: Text(title ?? "" , textAlign: TextAlign.center, style: AppTextStyle.appBarTitle.copyWith(fontSize: 16),),
        actions: [
          IconButton(icon: const Icon(CupertinoIcons.search, color: AppColor.primaryDark,), onPressed: (){
              locator<NavigationService>().pushNamed(Routes.search);
            },
          ),
          const CartButton.light(),
        ],
      ),
      body: ContentWrapper(widget.path, controller: controller,  onPageFetched: (pageSetting){
        if (mounted) {
          setState(() {
            title = pageSetting?.title;
          });
        }
      },)
    );
  }
}
