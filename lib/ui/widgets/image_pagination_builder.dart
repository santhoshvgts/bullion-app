import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class ImagePaginationBuilder extends StatelessWidget {
  int activeIndex = 0;

  Color? activeBorderColor;

  double? activeSize;

  double? size;

  List<String>? images;

  SwiperController controller;

  ImagePaginationBuilder({
    this.activeIndex = 0,
    this.activeBorderColor,
    this.activeSize,
    this.size,
    this.images,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...images!
                .asMap()
                .map((index, e) {
                  return MapEntry(
                    index,
                    InkWell(
                      onTap: () {
                        controller.move(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: index == activeIndex
                                    ? AppColor.primary
                                    : Colors.black.withOpacity(0.2),
                                width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(5),
                        child: NetworkImageLoader(
                          image: e,
                          fit: BoxFit.cover,
                          height: index == activeIndex ? activeSize : size,
                          width: index == activeIndex ? activeSize : size,
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList()
                .expand((e) => [
                      e,
                      const SizedBox(
                        width: 10,
                      )
                    ])
                .toList(),
          ]),
    );
  }
}
