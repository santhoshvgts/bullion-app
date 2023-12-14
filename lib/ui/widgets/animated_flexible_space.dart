import 'package:flutter/material.dart';

import '../../core/res/styles.dart';

//Used for pages with a SliverAppBar that do not contain tab views.
class AnimatedFlexibleSpace extends StatelessWidget {
  final String title;

  const AnimatedFlexibleSpace({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double percent = ((constraints.maxHeight - kToolbarHeight) *
          100 /
          (10 - kToolbarHeight));
      double dx = 0;

      dx = 100 + percent;

      //To reduce the space between start to end
      dx = (dx * 64) / 100;

      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight / 4, left: 16),
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
