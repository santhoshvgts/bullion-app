import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/action_button.dart';
import 'package:bullion/core/models/module/item_display_settings.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';

class ActionButtonItem extends StatelessWidget {
  final ActionButton? settings;
  final Color? textColor;
  final ItemDisplaySettings? itemDisplaySettings;

  const ActionButtonItem({super.key,  this.settings, this.textColor, this.itemDisplaySettings});

  onTap() {
    locator<NavigationService>().pushNamed(
      settings!.targetUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (settings!.style == ActionButtonStyle.link) {
      return InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(settings!.labelText!,
                  textScaleFactor: 1,
                  style: settings!.textStyle.copyWith(
                    color: settings!.textColor == null
                        ? textColor
                        : settings!.labelTextColor,
                  )),
              if (settings!.hasIcon!)
                Container(
                    width: 12,
                    child: Icon(
                      Icons.navigate_next,
                      color: textColor,
                    ))
            ],
          ));
    }

    // if (settings!.style == ActionButtonStyle.icon) {
    //   List<String> iconSplit = settings!.labelText!.split("|");
    //
    //   int iconCode = int.tryParse(iconSplit[0])!;
    //   String family = iconSplit[1];
    //   Color color = getColorFromString(iconSplit[2]);
    //   String? familyPackage = iconSplit.length > 2 ? iconSplit[3] : null;
    //
    //   print(iconCode);
    //   print(family);
    //
    //   return InkWell(
    //     onTap: onTap,
    //     child: Icon(
    //       IconData(iconCode, fontFamily: family, fontPackage: familyPackage),
    //       color: color,
    //     ),
    //   );
    // }

    return SizedBox(
      width: double.tryParse(itemDisplaySettings?.actionsWidth ?? ""),
      child: MaterialButton(
        onPressed: onTap,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: settings!.isOutline ? null : settings!.buttonColor,
        elevation: 0,
        textTheme: ButtonTextTheme.accent,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: settings!.buttonColor),
            borderRadius: BorderRadius.circular(5)),
        child: _buildDynamicPositionWrapper(children: [
          Text(
            settings!.labelText!,
            textScaleFactor: 1,
            style: settings!.textStyle,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          if (settings!.hasIcon!)
            Icon(
              Icons.navigate_next,
              color: settings!.buttonTextColor,
            )
        ]),
      ),
    );
  }

  Widget _buildDynamicPositionWrapper({List<Widget> children = const []}) {
    if (settings!.iconPosition!.contains("right") ||
        settings!.iconPosition!.contains("left")) {
      return Wrap(
        children: settings!.iconPosition!.contains("left")
            ? children.reversed.toList()
            : children,
      );
    } else {
      return Column(
        children: settings!.iconPosition!.contains("top")
            ? children.reversed.toList()
            : children,
      );
    }
  }
}
