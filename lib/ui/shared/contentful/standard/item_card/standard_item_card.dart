import 'package:bullion/ui/shared/contentful/module/action_button.dart';
import 'package:bullion/ui/shared/contentful/standard/item_card/standard_item_card_view_model.dart';
import 'package:bullion/ui/shared/contentful/standard/standard_text_style.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as MarkDown;
import 'package:bullion/core/constants/alignment.dart';
import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/constants/image_shape.dart';
import 'package:bullion/core/models/module/item_display_settings.dart';
import 'package:bullion/core/models/module/standard_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:stacked/stacked.dart';

class StandardItemCard extends StackedView<StandardItemCardViewModel> {

  final ItemDisplaySettings? itemDisplaySettings;
  final StandardItem item;

  StandardItemCard(this.item, {this.itemDisplaySettings});

  @override
  Widget builder(BuildContext context, StandardItemCardViewModel viewModel, Widget? child) {

    return InkWell(
      onTap: () => viewModel.onTap(),
      child: Container(
        padding: EdgeInsets.all(viewModel.itemDisplaySettings!.fullBleed || viewModel.itemDisplaySettings!.imagePosition == "top" ? 0 : viewModel.itemDisplaySettings!.cardPadding),
        margin: EdgeInsets.only(bottom: viewModel.itemDisplaySettings!.hasBoxShadow ? 3.5 : 0),
        decoration: BoxDecoration(
            color: viewModel.itemDisplaySettings!.backgroundColor,
            boxShadow: viewModel.itemDisplaySettings!.hasBoxShadow ? AppStyle.cardShadow : null,
            borderRadius: viewModel.itemDisplaySettings!.hasRoundedCorners ? BorderRadius.circular(10) : null,
            border: viewModel.itemDisplaySettings!.hasBorders ? Border.all() : null
        ),
        child: _StandardDynamicWrapper(
          imagePosition: viewModel.itemDisplaySettings!.imagePosition,
          contentKey: viewModel.contentSectionKey,
          children: [
            if (viewModel.item!.imageUrl != null)
              Align(
                alignment: UIAlignment.alignment(viewModel.itemDisplaySettings!.imagePosition),
                child: _ImageContainer(
                  shape: viewModel.itemDisplaySettings!.imageShape,
                  height: viewModel.itemDisplaySettings!.imageHeight,
                  child: NetworkImageLoader(
                    image: viewModel.item!.imageUrl,
                    fit: BoxFit.cover,
                    key: viewModel.imageSectionKey,
                    borderRadius: UIAlignment.imageShapeRadius(viewModel.itemDisplaySettings!.imageShape),
                    width: viewModel.itemDisplaySettings!.imageWidth,
                  ),
                ),
              ),

            if (item.hasContent)
              _StandardDynamicContentWrapper(
                key: viewModel.contentSectionKey,
                actionPosition: viewModel.itemDisplaySettings!.actionsAlignment,
                imagePosition: viewModel.itemDisplaySettings!.imagePosition,
                children: [

                  Column(
                    children: [

                      if (viewModel.item!.title != null && viewModel.item!.title != "")
                        Container(
                          alignment: UIAlignment.alignment(viewModel.itemDisplaySettings!.titleAlignment),
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(viewModel.item!.title!,
                              textAlign: UIAlignment.textAlign(viewModel.itemDisplaySettings!.titleAlignment),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: StandardTextStyle.title(viewModel.itemDisplaySettings!.titleStyle, color: viewModel.itemDisplaySettings!.textColor)
                          )
                        ),

                      if (viewModel.item!.subtitle != null && viewModel.item!.subtitle != "")
                        Container(
                          alignment: UIAlignment.alignment(viewModel.itemDisplaySettings!.titleAlignment),
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(viewModel.item!.subtitle!,
                              style: StandardTextStyle.subtitle(viewModel.itemDisplaySettings!.titleStyle, color: viewModel.itemDisplaySettings!.textColor)),
                        ),

                      if (viewModel.item!.content != null && viewModel.item!.content != "")
                       _ContentView()
                    ],
                  ),

                  if (viewModel.item!.actions != null)
                    if (viewModel.item!.actions!.length > 0)
                      Container(
                        alignment: UIAlignment.alignment(viewModel.itemDisplaySettings!.actionsAlignment),
                        margin: EdgeInsets.only(top: 0),
                        child: Wrap(
                          alignment: UIAlignment.wrapAlignment(viewModel.itemDisplaySettings!.actionsAlignment),
                          children: viewModel.item!.actions!.map((actionItem) => ActionButtonItem(
                                settings: actionItem,
                                textColor: viewModel.itemDisplaySettings!.textColor,
                              )
                          ).toList(),
                        ),
                      ),
                ],
              )

          ],
        ),
      ),
    );
  }

  @override
  StandardItemCardViewModel viewModelBuilder(BuildContext context) => StandardItemCardViewModel(item: item, itemDisplaySettings: itemDisplaySettings);

}

class _ContentView extends ViewModelWidget<StandardItemCardViewModel> {

  @override
  Widget build(BuildContext context, StandardItemCardViewModel viewModel) {

    switch(viewModel.item!.contentType) {
      case ContentType.html:
        return ApmexHtmlWidget(viewModel.item!.content);

      case ContentType.markdown:
        return ApmexHtmlWidget(MarkDown.markdownToHtml(viewModel.item!.content!),);

      case ContentType.text:
      default:
        return Container(
          alignment: UIAlignment.alignment(viewModel.itemDisplaySettings!.contentAlignment),
          child: Text(viewModel.item!.content!,
            style: StandardTextStyle.content(viewModel.itemDisplaySettings!.contentStyle, color: viewModel.itemDisplaySettings!.textColor),
            textAlign: UIAlignment.textAlign(viewModel.itemDisplaySettings!.contentAlignment),
          ),
        );
    }

  }


}

class _StandardDynamicWrapper extends StatelessWidget {

  final String? imagePosition;
  final List<Widget>? children;
  final GlobalKey? contentKey;
  final Key? key;

  List<Widget>? get _children {
    if (imagePosition!.contains("bottom") || imagePosition!.contains("right")){
      return children!.reversed.toList();
    }
    return children;
  }

  _StandardDynamicWrapper({this.key, this.contentKey, this.imagePosition, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if ((imagePosition!.contains("right") || imagePosition!.contains("left")) && imagePosition != "center"){
      return Row(
        children: _children!.map((e){
          if (e.key == contentKey){
            return Expanded(child: e);
          }
          return e;
        }).toList(),
      );
    }

    return Column(
      children: _children!,
    );
  }

}

class _StandardDynamicContentWrapper extends ViewModelWidget<StandardItemCardViewModel> {
  final String? actionPosition;
  final String? imagePosition;
  final List<Widget>? children;
  final Key? key;

  List<Widget>? get _children {
    if (actionPosition!.contains("top")){
      return children!.reversed.toList();
    }
    return children;
  }

  _StandardDynamicContentWrapper({this.key, this.imagePosition, this.actionPosition, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context, StandardItemCardViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(
        top: (imagePosition!.contains("right") || imagePosition!.contains("left")) && imagePosition != "center" ? 0 : 5,
        left: imagePosition == "left" ? 10 : 0
      ),
      padding: EdgeInsets.all(imagePosition == "top" ? viewModel.itemDisplaySettings!.cardPadding : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _children!,
      ),
    );
  }

}

class _ImageContainer extends StatelessWidget {

  final String? shape;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final Widget? child;
  final Key? key;

  _ImageContainer({this.key, this.shape, this.height, this.width, this.backgroundColor, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            shape: shape == ImageShape.round ? BoxShape.circle : BoxShape.rectangle,
            color: backgroundColor
        ),
        child: child
    );
  }

}