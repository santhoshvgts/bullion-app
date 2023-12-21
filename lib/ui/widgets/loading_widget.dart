import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/widgets.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerEffect(
          height: 85,
          width: double.infinity,
        ),
        Container(
          height: 90,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          width: double.infinity,
          child: ShimmerEffect(),
        ),
        Container(
          height: 90,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          width: double.infinity,
          child: ShimmerEffect(),
        ),
        Container(
          height: 190,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          width: double.infinity,
          child: ShimmerEffect(),
        )
      ],
    );
  }
}