import 'package:bullion/core/models/module/product_detail/product_picture.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/widgets/image_pagination_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:photo_view/photo_view.dart';

class ProductImagesFullViewPage extends StatefulWidget {

  final List<ProductPicture>? images;
  int activeIndex;

  ProductImagesFullViewPage(this.images, this.activeIndex);

  @override
  State<ProductImagesFullViewPage> createState() => _ProductImagesFullViewPageState();
}

class _ProductImagesFullViewPageState extends State<ProductImagesFullViewPage> {

  SwiperController controller = SwiperController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [

              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  String image = widget.images![index].fullSizeImageUrl!;
                  return PhotoView(
                      imageProvider: CachedNetworkImageProvider(
                        image == null ? "" : ( image!.contains("testsite.bullion.com") ? image!.replaceAll("testsite.bullion.com", "www.images-bullion.com") : image! ),
                        maxHeight: 100,
                        errorListener: (d) {
                          print(d.toString());
                        }
                      ),
                      backgroundDecoration: const BoxDecoration(color: AppColor.white),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      loadingBuilder: (context, event) {
                        if (event == null) {
                          return const Center(child:CircularProgressIndicator());
                        } else {
                          return Container();
                        }
                      }
                    );
                },
                autoplay: false,
                loop: false,
                index: widget.activeIndex,
                itemCount: widget.images!.length,
                onIndexChanged: (int index) {
                  setState(() {
                    widget.activeIndex = index;
                  });
                },
                // pagination: SwiperPagination(
                //   alignment: Alignment.bottomCenter,
                //   builder: ImagePaginationBuilder(
                //     activeBorderColor: AppColor.primary,
                //     activeSize: 60,
                //     size: 50,
                //     images: images,
                //     controller: controller,
                //   )
                // ),
              ),

              Positioned(
                bottom: 25,
                left: 0,
                right: 0,
                child: Center(
                  child: ImagePaginationBuilder(
                      activeBorderColor: AppColor.primary,
                      activeSize: 70,
                      size: 70,
                      images: widget.images?.map((e) => e.imageUrl!).toList() ?? [],
                      activeIndex: widget.activeIndex,
                      controller: controller
                  ),
                ),
              ),

              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
