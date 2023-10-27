import 'package:bullion/core/res/images.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class AnimatedLogoLoading extends StatelessWidget {
  final Widget child;
  const AnimatedLogoLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Expanded(
            child: Container(
          color: Colors.black38,
        )),
        Center(
          child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 30,
                width: 30,
                child: GifView.asset(
                  Gif.appBullLogo,
                  height: 30,
                  width: 30,
                  frameRate: 30, // default is 15 FPS
                ),
              )),
        ),
      ],
    );
  }
}
