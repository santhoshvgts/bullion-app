import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final double size;
  final Color color;

  const Dot({super.key, this.size = 10.0, this.color = const Color(0xff626A7D)});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int activeIndex;

  const PageIndicator({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Dot(
            size: activeIndex == index ? 8.0 : 5.0,
            color: const Color(0xFF626A7D).withOpacity(activeIndex == index ? 1.0 : 0.24),
          ),
        );
      }),
    );
  }
}
