import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
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
          backgroundColor: AppColor.primary,
          elevation: 0,
          centerTitle: false,
          title: Image.asset(
            Images.appLogo,
            height: 18,
          ),
          actions: const [CartButton()],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: _Search(),
          ),
        ),
        // appBar: AppBar(
        //  centerTitle: true,
        //   elevation: 1,
        //   titleSpacing: 0,
        //   title: Text(title ?? "" , textAlign: TextAlign.center, style: AppTextStyle.appBarTitle.copyWith(fontSize: 16),),
        //   actions: [
        //     IconButton(icon: const Icon(Icons.search,color: AppColor.primaryDark,), onPressed: (){
        //         locator<NavigationService>().pushNamed(Routes.search);
        //       },
        //     ),
        //     // HomeButton(),
        //     // CartButton(),
        //   ],
        // ),
        body: ContentWrapper(
          widget.path,
          controller: controller,
          onPageFetched: (pageSetting) {
            if (mounted) {
              setState(() {
                title = pageSetting?.title;
              });
            }
          },
        ));
  }
}

class _AppBar extends StatelessWidget {
  final String path;
  _AppBar(this.path);

  @override
  Widget build(
    BuildContext context,
  ) {
    return AppBar(
      backgroundColor: AppColor.secondaryBackground,
      titleSpacing: 0,
      elevation: 0,
      title: _Search(),
      actions: const [CartButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Search extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {},
      child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(color: AppColor.white.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(7.0)), border: Border.all(color: Colors.black12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                Images.search,
                width: 15,
                color: Colors.white,
              ),
              HorizontalSpacing.d10px(),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  "Search Products and Deals",
                  style: AppTextStyle.text.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                  textScaleFactor: 1,
                ),
              )
            ],
          )),
    );
  }
}
