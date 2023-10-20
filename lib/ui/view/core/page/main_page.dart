import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/shared/search_card_section.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:flutter/material.dart';

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
          scrolledUnderElevation: 3,
          titleSpacing: 0,
          title: SearchCardSection(
            rightPadding: 0,
            leftPadding: 0,
            placeholder: title,
          ),
          actions: const [
            CartButton.light(),
          ],
        ),
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
