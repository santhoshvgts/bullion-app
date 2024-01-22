import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/contentful/product/product_text_style.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:flutter/material.dart';

enum ProductItemCardType { Favorite, AlertMe, PriceAlert }

class ProductItemCard extends StatelessWidget {
  final ProductDetails detail;
  final ProductItemCardType type;
  final Function(ProductDetails)? onDeleteClick;
  final Function(ProductDetails)? onPressed;

  ProductOverview? get item => detail.overview;

  ProductItemCard(this.detail, this.type, {this.onDeleteClick, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key("actionProduct${detail.productId}"),
      onTap: () => locator<NavigationService>()
          .pushNamed(detail.overview!.targetUrl, arguments: detail),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 0, top: 15, bottom: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImageLoader(
              image: item!.primaryImageUrl,
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item!.name!,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ProductTextStyle.title(2,
                            color: AppColor.black)),
                    VerticalSpacing.d10px(),
                    _PriceSection(item, Alignment.centerLeft, type),
                    if (type == ProductItemCardType.AlertMe)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        child: Text(
                          "Quantity: ${detail.requestedQty}",
                          textScaleFactor: 1,
                          style: AppTextStyle.titleMedium,
                        ),
                      )
                    else if (type == ProductItemCardType.PriceAlert)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        child: Text(
                          "Your Price: ${detail.formatedYourPrice}",
                          textScaleFactor: 1,
                          style: AppTextStyle.titleMedium,
                        ),
                      )
                  ],
                ),
              ),
            ),
            if (type == ProductItemCardType.Favorite &&
                onDeleteClick != null)
              IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onDeleteClick!(detail))
            else if (onDeleteClick != null)
              IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // onDeleteClick(detail);
                    locator<DialogService>()
                        .showBottomSheet(child: _buildBottomAction());
                  })
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              child: MaterialButton(
                minWidth: double.infinity,
                onPressed: () {
                  locator<DialogService>().dialogComplete(AlertResponse());
                  onPressed!(detail);
                },
                child: const Row(
                  children: [
                    Text(
                      "Edit",
                      textScaleFactor: 1,
                      style: AppTextStyle.labelMedium,
                    ),
                  ],
                ),
              ),
              width: double.infinity,
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  locator<DialogService>().dialogComplete(AlertResponse());
                  onDeleteClick!(detail);
                },
                child: const Row(
                  children: [
                    Text(
                      "Remove",
                      textScaleFactor: 1,
                      style: AppTextStyle.labelMedium,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  final ProductOverview? item;
  final Alignment alignment;
  final ProductItemCardType type;

  _PriceSection(this.item, this.alignment, this.type);

  @override
  Widget build(BuildContext context) {
    if (item!.productAction == ProductInfoDisplayType.addToCart) {
      List<Widget> priceList = [
        Text(
          "${item!.pricing!.formattedNewPrice}",
          style: ProductTextStyle.price(2, color: AppColor.black).copyWith(
              color: item!.pricing!.strikeThroughEnabled!
                  ? const Color(0xffC30000)
                  : AppColor.primaryDark),
          textScaleFactor: 1,
        ),
        if (item!.pricing!.strikeThroughEnabled!)
          Text(
            item!.pricing!.formattedOldPrice!,
            textScaleFactor: 1,
            style: ProductTextStyle.strikedPrice(2, color: AppColor.green)
                .copyWith(
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff666666),
                    decoration: TextDecoration.lineThrough),
          ),
      ];

      return Column(
        crossAxisAlignment: alignment == Alignment.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 5,
            children: priceList,
          ),
          if (item!.pricing!.badgeText != null)
            Container(
              padding: const EdgeInsets.only(top: 5),
              alignment: alignment,
              child: Text(
                item!.pricing!.badgeText!,
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: ProductTextStyle.badge(2, color: AppColor.black),
              ),
            ),
          if (item!.pricing!.strikeThroughEnabled!)
            Container(
              padding: const EdgeInsets.only(top: 5),
              alignment: alignment,
              child: Text(
                item!.pricing!.discountText!,
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: ProductTextStyle.badge(2, color: AppColor.black),
              ),
            ),
        ],
      );
    }

    return Container(
        alignment: alignment,
        child: Text(
          item!.availabilityText!,
          textAlign: TextAlign.left,
          textScaleFactor: 1,
          style: AppTextStyle.titleLarge
              .copyWith(color: AppColor.red, fontSize: 16),
        ));
  }
}
