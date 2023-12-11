import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/constants/constants.dart';

/// Applies a staggered animation effect to any child widget.
///
/// Wrap a list/grid child widget in this class and pass required parameters
/// to animate the child elements sequentially on screen.
///
/// * [index] index of the child widget in the list/grid
/// * [child] the individual widget to animate
/// * [isList] whether child widget is in a ListView
/// * [columnCount] columns count if child is in a GridView

class StaggeredAnimation extends StatelessWidget {
  final bool isList;
  final int index, columnCount;
  final Widget child;

  const StaggeredAnimation.staggeredList({
    super.key,
    required this.index,
    required this.child,
    this.isList = false,
  }) : columnCount = 0;

  const StaggeredAnimation.staggeredGrid({
    super.key,
    required this.index,
    required this.child,
    required this.columnCount,
    this.isList = true,
  });

  @override
  Widget build(BuildContext context) {
    return isList
        ? AnimationConfiguration.staggeredList(
            position: index,
            duration:
                const Duration(milliseconds: Constants.staggeredListDuration),
            child: SlideAnimation(
              verticalOffset: Constants.slideVerticalOffset,
              child: FadeInAnimation(child: child),
            ),
          )
        : AnimationConfiguration.staggeredGrid(
            position: index,
            duration:
                const Duration(milliseconds: Constants.staggeredGridDuration),
            columnCount: columnCount,
            child: SlideAnimation(
              verticalOffset: Constants.slideVerticalOffset,
              child: FadeInAnimation(child: child),
            ),
          );
  }
}
