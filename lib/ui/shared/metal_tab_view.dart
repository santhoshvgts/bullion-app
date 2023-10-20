import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';

class SelfRedirectEvent implements Event {
  String currentUrl;
  String targetUrl;

  SelfRedirectEvent(this.currentUrl, this.targetUrl);
}

class MetalTabView extends StatefulWidget {
  List<String>? metalList;
  Function(int index, String metalName)? onChange;
  int? initialIndex;
  List<Widget> children;
  bool isSwipable;

  MetalTabView(
      {this.metalList,
      this.initialIndex,
      this.onChange,
      this.isSwipable = true,
      this.children = const []});

  @override
  _MetalTabViewState createState() => _MetalTabViewState();
}

class _MetalTabViewState extends State<MetalTabView>
    with SingleTickerProviderStateMixin {
  String get metalName => widget.metalList![widget.initialIndex!];

  TabController? controller;

  @override
  void initState() {
    controller = new TabController(
        length: widget.metalList!.length,
        initialIndex: widget.initialIndex!,
        vsync: this);

    controller!.addListener(() {
      print(controller!.indexIsChanging);
      print(controller!.index);

      if (!controller!.indexIsChanging) {
        setState(() {
          widget.onChange!(
              controller!.index, widget.metalList![controller!.index]);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: controller,
            onTap: (int index) {
              // widget.onChange(index, widget.metalList[index]);
            },
            automaticIndicatorColorAdjustment: true,
            labelColor:
                AppColor.metalColor(widget.metalList![controller!.index]),
            unselectedLabelColor: AppColor.black20,
            indicatorColor:
                AppColor.metalColor(widget.metalList![controller!.index]),
            labelStyle:
                AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTextStyle.bodyLarge,
            isScrollable: true,
            tabs: [
              ...widget.metalList!
                  .map((e) => SizedBox(
                      width: (widget.metalList!.length * (65 + 15)) >
                              MediaQuery.of(context).size.width
                          ? null
                          : 65,
                      child: Tab(
                        text: e,
                      )))
                  .toList()
            ],
          ),
        ),
        Flexible(
            child: TabBarView(
          controller: controller,
          children: widget.children,
          physics: widget.isSwipable
              ? ClampingScrollPhysics()
              : NeverScrollableScrollPhysics(),
        )),
      ],
    );
  }
}
