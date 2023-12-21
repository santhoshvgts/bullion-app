import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';

class CkShippingOption extends ViewModelWidget<CheckoutPageViewModel> {
  const CkShippingOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.only(top: 30, left: 15), child: Text('Shipping Options', style: AppTextStyle.titleSmall)),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 12),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value:false ,
                        activeColor: AppColor.primary,
                        fillColor: const MaterialStatePropertyAll(AppColor.primary),
                        groupValue: true,
                        onChanged: (value) {
                              print(value);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(viewModel.checkout!.selectedShippingOption!.shippingOptions?[index].name ?? '', style: AppTextStyle.bodyMedium,maxLines: 1,),
                            // VerticalSpacing.d2px(),
                            // Text(
                            //   viewModel.checkout!.selectedShippingOption!.shippingOptions?[index].serviceDescription ?? '',
                            //   style: AppTextStyle.bodySmall.copyWith(fontSize: 10, color: Colors.black54),
                            //   maxLines: 2,
                            // ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text('\$${viewModel.checkout!.selectedShippingOption!.shippingOptions?[index].shipCharge.toString() ?? ''}', style: AppTextStyle.bodyMedium.copyWith(color: AppColor.text)),
                      HorizontalSpacing.d15px(),
                    ],
                  ),
              separatorBuilder: (context, index) => const Divider(
                    color: AppColor.divider,
                    thickness: 0.3,
                    height: 15,
                  ),
              itemCount: viewModel.checkout?.selectedShippingOption?.shippingOptions?.length ?? 0)),
      // Column(
      //   children: [
      //     Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Radio(
      //           value: true,
      //           activeColor: AppColor.primary,
      //           fillColor: const MaterialStatePropertyAll(AppColor.primary),
      //           groupValue: true,
      //           onChanged: (value) {},
      //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //         ),
      //         Expanded(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const Text('Express Delivery', style: AppTextStyle.bodyMedium),
      //               VerticalSpacing.d2px(),
      //               Text(
      //                 'Expeted to delivery within 11, Tue',
      //                 style: AppTextStyle.bodySmall.copyWith(fontSize: 10, color: Colors.black54),
      //                 maxLines: 2,
      //               ),
      //             ],
      //           ),
      //         ),
      //         // const Spacer(),
      //         Text('\$7.90', style: AppTextStyle.bodyMedium.copyWith(color: AppColor.text)),
      //         HorizontalSpacing.d15px(),
      //       ],
      //     ),
      //     const Divider(thickness: 0.6, color: Colors.black12, height: 15),
      //     Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Radio(
      //           value: true,
      //           activeColor: AppColor.primary,
      //           fillColor: const MaterialStatePropertyAll(AppColor.primary),
      //           groupValue: false,
      //           onChanged: (value) {},
      //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //         ),
      //         Expanded(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const Text('Standard Delivery', style: AppTextStyle.bodyMedium),
      //               VerticalSpacing.d2px(),
      //               Text(
      //                 'Expeted to delivery within 18, Fri',
      //                 style: AppTextStyle.bodySmall.copyWith(fontSize: 10, color: Colors.black54),
      //                 maxLines: 2,
      //               ),
      //             ],
      //           ),
      //         ),
      //         // const Spacer(),
      //         Text('Free', style: AppTextStyle.bodyMedium.copyWith(color: AppColor.greenText)),
      //         HorizontalSpacing.d15px(),
      //       ],
      //     ),
      //   ],
      // ),
    ]);
  }
}

// Radio(
//                 value: true,
//                 activeColor: AppColor.primary,
//                 fillColor: const MaterialStatePropertyAll(AppColor.primary),
//                 groupValue: true,
//                 onChanged: (value) {},
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Express Delivery', style: AppTextStyle.bodyMedium),
//                     VerticalSpacing.d2px(),
//                     Text(
//                       'Expeted to delivery within 11, Tue',
//                       style: AppTextStyle.bodySmall.copyWith(fontSize: 10, color: Colors.black54),
//                       maxLines: 2,
//                     ),
//                   ],
//                 ),
//               ),
//               // const Spacer(),
//               Text('\$7.90', style: AppTextStyle.bodyMedium.copyWith(color: AppColor.text)),
//               HorizontalSpacing.d15px(),
//             ],
//           ),