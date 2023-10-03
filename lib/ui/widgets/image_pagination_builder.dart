import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class ImagePaginationBuilder extends SwiperPlugin {
  Color? activeBorderColor;

  double? activeSize;

  double? size;

  List<String>? images;

  ImagePaginationBuilder(
      {this.activeBorderColor, this.activeSize, this.size, this.images});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
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
                        config.controller.move(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: index == config.activeIndex
                                    ? AppColor.primary
                                    : Colors.black.withOpacity(0.2),
                                width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(5),
                        child: NetworkImageLoader(
                          image: e,
                          fit: BoxFit.cover,
                          height:
                              index == config.activeIndex ? activeSize : size,
                          width:
                              index == config.activeIndex ? activeSize : size,
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
