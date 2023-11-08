import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/res/styles.dart';

class SpotPriceTabBar extends StatefulWidget {
  final List<SpotPrice> tabList;
  final int? initialIndex;
  final ScrollController controller;
  final Function(int index, String name) onChange;

  const SpotPriceTabBar({
    super.key,
    required this.tabList,
    required this.initialIndex,
    required this.onChange,
    required this.controller,
  });

  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<SpotPriceTabBar> {
  @override
  void initState() {
    setState(() {
      if (widget.initialIndex != null) {
        Future.delayed(const Duration(milliseconds: 110)).then((value) {
          widget.controller.animateTo(
            widget.initialIndex! * 100,
            duration: const Duration(milliseconds: 500),
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
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: widget.controller,
        child: Row(
          children: widget.tabList
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
                                widget.onChange(index, item.targetUrl ?? '');
                              });
                            },
                            child: _SpotPriceStripCard(
                              item,
                              isSelected:
                                  widget.initialIndex == index ? true : false,
                            ),
                          ),
                  );
                },
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}

class _SpotPriceStripCard extends StatelessWidget {
  final SpotPrice data;
  final bool isSelected;

  const _SpotPriceStripCard(this.data, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: isSelected ? Border.all(color: data.color, width: 1.5) : null,
        // borderRadius: BorderRadius.circular(8),
        // color: isSelected ? data.color.withOpacity(0.2) : AppColor.white,
        border: isSelected
            ? Border(
                bottom: BorderSide(
                  color: data.color,
                  width: 2.5,
                ),
              )
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.metalName!,
            textScaleFactor: 1,
            style: AppTextStyle.titleSmall,
          ),
          // VerticalSpacing.d5px(),
          // Row(
          //   children: [
          //     Text(
          //       data.formattedAsk!,
          //       textScaleFactor: 1,
          //       style: AppTextStyle.bodySmall.copyWith(),
          //     ),
          //     HorizontalSpacing.d5px(),
          //     Text(
          //       (data.change! < 0 ? "-" : "+") + "${data.formattedChange}",
          //       textScaleFactor: 1,
          //       style: AppTextStyle.bodySmall.copyWith(
          //         color: data.change! < 0 ? AppColor.red : AppColor.green,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
