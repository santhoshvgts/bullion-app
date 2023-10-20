import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/res/colors.dart';
import '../../../../../../core/res/spacing.dart';
import '../../../../../../core/res/styles.dart';

class SpotPriceTabBar extends StatefulWidget {
  final List<SpotPrice>? tabList;
  final int? initialIndex;
  final ScrollController controller;
  final Function(int index, String name) onChange;

  SpotPriceTabBar(
      {required this.tabList,
      required this.initialIndex,
      required this.onChange,
      required this.controller});

  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<SpotPriceTabBar> {
  @override
  void initState() {
    setState(() {
      if (widget.initialIndex != null) {
        Future.delayed(Duration(milliseconds: 110)).then((value) {
          widget.controller.animateTo(
            widget.initialIndex! * 100,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: widget.controller,
        padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 5, bottom: 5),
        child: Row(
            children: widget.tabList!
                .asMap()
                .map(
                  (index, item) {
                    return MapEntry(
                        index,
                        item.metalName == 'Portfolio'
                            ? Container()
                            : InkWell(
                                radius: 20,
                                onTap: () {
                                  setState(() {
                                    widget.onChange(
                                        index, item.targetUrl ?? '');
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: _SpotPriceStripCard(item,
                                      isSelected: widget.initialIndex == index
                                          ? true
                                          : false),
                                ),
                              ));
                  },
                )
                .values
                .toList()),
      ),
    );
  }
}

class _SpotPriceStripCard extends StatelessWidget {
  final SpotPrice data;
  final bool isSelected;

  _SpotPriceStripCard(this.data, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? data.color.withOpacity(0.2) : AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: data.color, width: 1.5)),
      padding: EdgeInsets.only(bottom: 7, left: 8.0, right: 8.0, top: 7.0),
      child: Row(
        children: [
          HorizontalSpacing.d5px(),
          Text(data.metalName!,
              textScaleFactor: 1,
              style: AppTextStyle.labelSmall
                  .copyWith(fontWeight: FontWeight.w600)),
          HorizontalSpacing.d5px(),
          Text(data.formattedAsk!,
              textScaleFactor: 1,
              style: AppTextStyle.labelSmall
                  .copyWith(fontWeight: FontWeight.w600)),
          HorizontalSpacing.d5px(),
          Text("${data.change! < 0 ? "-" : "+"}" + "${data.formattedChange}",
              textScaleFactor: 1,
              style: AppTextStyle.labelSmall.copyWith(
                  color: data.change! < 0 ? AppColor.red : AppColor.green,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
