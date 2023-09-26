
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class ImagePaginationBuilder extends SwiperPlugin {

  Color? activeBorderColor;

  double? activeSize;

  double? size;

  List<String>? images;

  ImagePaginationBuilder({this.activeBorderColor, this.activeSize, this.size, this.images});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: images!.asMap().map((index, e){
          return MapEntry(index, InkWell(
            onTap: (){
              config.controller.move(index);
            },
            child: Container(
                decoration: BoxDecoration(
                  border: index == config.activeIndex ? Border.all(color: activeBorderColor!, width: 1) : null,
                  borderRadius: BorderRadius.circular(5)
                ),
                padding: const EdgeInsets.all(5),
                child: NetworkImageLoader(
                  image: e,
                  fit: BoxFit.cover,
                  height: index == config.activeIndex ? activeSize : size,
                  width: index == config.activeIndex ? activeSize : size,
                ),
              ),
          ),
          );
        }).values.toList().expand((e) => [e, const SizedBox(width: 10,)]).toList(),
      ),
    );

  }

}