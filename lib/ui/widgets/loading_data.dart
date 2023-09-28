import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingData extends StatelessWidget {

  bool showGraphShimmer;

  LoadingData({ this.showGraphShimmer = false });

  @override
  Widget build(BuildContext context) {
  return Container(
    color: AppColor.white,
    child: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
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
            ShimmerEffect(height: 150, color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),

          ShimmerEffect(height: 25,width:150,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),

         Container(
           height: 120,
           child: ListView.builder(
                itemCount: 5,
               primary: false,
               physics: NeverScrollableScrollPhysics(),
               scrollDirection: Axis.horizontal,
               itemBuilder:(BuildContext context,index) {
               return ShimmerEffect(shape:BoxShape.circle,width: 100,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),);
           }),
         ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ShimmerEffect(height:150,width:(MediaQuery.of(context).size.width/2)-20,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),


              ShimmerEffect(height:150,width:(MediaQuery.of(context).size.width/2)-20,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),

            ],
          ),


          ShimmerEffect(height: 25,width:150,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ShimmerEffect(height:150,width:(MediaQuery.of(context).size.width/2)-20,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),


              ShimmerEffect(height:150,width:(MediaQuery.of(context).size.width/2)-20,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),

            ],
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: 500,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                 ShimmerEffect(height:150,width:230,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),
                 ShimmerEffect(height:150,width:230,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),
                 ShimmerEffect(height:150,width:230,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),
                 ShimmerEffect(height:150,width:230,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),
                 ShimmerEffect(height:150,width:230,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),
                 ShimmerEffect(height:150,width:230,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),
                 ShimmerEffect(height:150,width:230,color: AppColor.secondaryBackground,margin:EdgeInsets.all(10.0),),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
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