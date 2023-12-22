import 'package:bullion/core/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../core/res/styles.dart';

/// Creates a flexible space bar to animate page title text on scroll in
/// a [SliverAppBar].
///
/// The title text translates both horizontally and vertically on scroll to
/// create a parallax effect for pages with a [SliverAppBar].
///
/// * [title] text to show and animate for the current page.
/// * [hasTabBar] whether the TabBar is in the SliverAppBar, used to adjust the
/// appearance of the flexible space.

class AnimatedFlexibleSpace extends StatelessWidget {
  final String title;
  final bool hasTabBar;

  const AnimatedFlexibleSpace.withoutTab({
    super.key,
    required this.title,
  }) : hasTabBar = false;

  const AnimatedFlexibleSpace.withTab({super.key, required this.title})
      : hasTabBar = true;

  @override
  Widget build(BuildContext context) {
    return hasTabBar
        ? Padding(
      padding: const EdgeInsets.only(bottom: kTextTabBarHeight),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double percent =
          (((constraints.maxHeight - 56) - kToolbarHeight) *
              100 /
              (10 - kToolbarHeight));

          double dx = -13 + percent;
          // if (constraints.maxHeight == 100) {
          //   dx = 0;
          // }

          //To reduce the space between start to end
          dx = (dx * Constants.horizontalTextSpace) / 100;

          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight / 4,
                  left: 16,
                ),
                child: Transform.translate(
                  offset:
                  Offset(dx, constraints.maxHeight - kToolbarHeight),
                  child: Text(title, style: AppTextStyle.titleLarge),
                ),
              ),
            ],
          );
        },
      ),
    )
        : LayoutBuilder(builder: (context, constraints) {
      double percent = ((constraints.maxHeight - kToolbarHeight) *
          100 /
          (10 - kToolbarHeight));

      double dx = 100 + percent;

      //To reduce the space between start to end
      dx = (dx * Constants.horizontalTextSpace) / 100;

      return Stack(
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.only(top: kToolbarHeight / 4, left: 16),
            child: Transform.translate(
              offset: Offset(dx, constraints.maxHeight - kToolbarHeight),
              child: Text(title, style: AppTextStyle.titleLarge),
            ),
          ),
        ],
      );
    });
  }
}