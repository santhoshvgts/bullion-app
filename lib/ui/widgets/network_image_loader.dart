import 'package:bullion/core/res/images.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NetworkImageLoader extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadius borderRadius;
  final GlobalKey? key;

  const NetworkImageLoader({this.key, this.image, this.height, this.width, this.fit, this.borderRadius = BorderRadius.zero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: width,
        child: CachedNetworkImage(
          imageUrl: image == null ? "" : ( image!.contains("testsite.bullion.com") ? image!.replaceAll("testsite.bullion.com", "www.images-bullion.com") : image! ),
          fit: fit,
          height: height,
          width: width,
          cacheManager: CacheManager(Config(image!, stalePeriod: const Duration(days: 3))),
          placeholder: (context, url) => Container(
              width: width == double.infinity ? 90 : width,
              height: width == double.infinity ? 90 : width,
              padding: const EdgeInsets.all(20),
              child: const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 100,
                ),
              )
          ),
          errorWidget: (context, url, error) => Container(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                Images.appLogo,
                height: height,
                width: width,
              )),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}