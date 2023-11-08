import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';

enum LoadingStyle { LOGO, DEFAULT }

class LoadingData extends StatelessWidget {
  late bool showGraphShimmer;
  late LoadingStyle loadingStyle;

  LoadingData({
    super.key,
    this.showGraphShimmer = false,
    this.loadingStyle = LoadingStyle.DEFAULT,
  });

  @override
  Widget build(BuildContext context) {
    if (loadingStyle == LoadingStyle.LOGO) {
      return Container(
        height: MediaQuery.of(context).size.height / 1.2,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
        child: Center(
          child: Stack(
            children: [
              const Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Image.asset(
                    Images.appBullLogo,
                    width: 50,
                    height: 50,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      color: AppColor.white,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (showGraphShimmer)
            //   Container(
            //     height: MediaQuery.of(context).size.height / 2.5,
            //     child: Sparkline(
            //       data: [ 16, 18, 10, 9, 8, 7,8, 9, 12, 5,3 ,4, 5,6,7, 8, 0, 5,4, 10, ].map((f) => f.toDouble()).toList().cast<double>(),
            //       lineWidth: 1,
            //       lineColor: Color(0xfff7f7f7),
            //       fillColor: Color(0xfff7f7f7),
            //       fillMode: FillMode.below,
            //     )
            //   )
            // else
            ShimmerEffect(
              height: 150,
              color: AppColor.secondaryBackground,
              margin: const EdgeInsets.all(10.0),
            ),

            ShimmerEffect(
              height: 25,
              width: 150,
              color: AppColor.secondaryBackground,
              margin: const EdgeInsets.all(10.0),
            ),

            Container(
              height: 120,
              child: ListView.builder(
                  itemCount: 5,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, index) {
                    return ShimmerEffect(
                      shape: BoxShape.circle,
                      width: 100,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    );
                  }),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerEffect(
                  height: 150,
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  color: AppColor.secondaryBackground,
                  margin: const EdgeInsets.all(10.0),
                ),
                ShimmerEffect(
                  height: 150,
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  color: AppColor.secondaryBackground,
                  margin: const EdgeInsets.all(10.0),
                ),
              ],
            ),

            ShimmerEffect(
              height: 25,
              width: 150,
              color: AppColor.secondaryBackground,
              margin: const EdgeInsets.all(10.0),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerEffect(
                  height: 150,
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  color: AppColor.secondaryBackground,
                  margin: const EdgeInsets.all(10.0),
                ),
                ShimmerEffect(
                  height: 150,
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  color: AppColor.secondaryBackground,
                  margin: const EdgeInsets.all(10.0),
                ),
              ],
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                height: 500,
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    ShimmerEffect(
                      height: 150,
                      width: 230,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    ),
                    ShimmerEffect(
                      height: 150,
                      width: 230,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    ),
                    ShimmerEffect(
                      height: 150,
                      width: 230,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    ),
                    ShimmerEffect(
                      height: 150,
                      width: 230,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    ),
                    ShimmerEffect(
                      height: 150,
                      width: 230,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    ),
                    ShimmerEffect(
                      height: 150,
                      width: 230,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    ),
                    ShimmerEffect(
                      height: 150,
                      width: 230,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingSection extends StatelessWidget {
  const LoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppColor.primary),
          ),
        ),
      ),
    );
  }
}
