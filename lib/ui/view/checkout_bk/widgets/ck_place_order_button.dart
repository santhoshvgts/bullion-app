// import 'package:bullion/core/res/colors.dart';
// import 'package:bullion/core/res/images.dart';
// import 'package:bullion/ui/view/checkout_bk/checkout_view_model.dart';
// import 'package:bullion/ui/widgets/button.dart';
// import 'package:flutter/widgets.dart';
// import 'package:stacked/stacked.dart';
//
// class CkPlaceOrderButton extends ViewModelWidget<CheckoutPageViewModel> {
//   const CkPlaceOrderButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
//     if (viewModel.paymentMethod != null) {
//       if (viewModel.paymentMethod!.paymentMethodId == 18) {
//         return Button.image(
//           Images.payPal,
//           viewModel.paymentMethod!.icon,
//           valueKey: const Key("btnPlaceOrder"),
//           width: double.infinity,
//           disabled: !viewModel.enablePlaceOrder,
//           loading: viewModel.placeOrderLoading,
//           borderRadius: BorderRadius.circular(5),
//           color: const Color(0xFF023087),
//           borderColor: const Color(0xFF023087),
//           onPressed: viewModel.isBusy
//               ? null
//               : () {
//                   viewModel.onPayPalClick();
//                 },
//         );
//       }
//
//       if (viewModel.paymentMethod!.paymentMethodId == 28) {
//         return Button.image(
//           Images.bitpay,
//           viewModel.paymentMethod!.icon,
//           valueKey: const Key("btnPlaceOrder"),
//           width: double.infinity,
//           disabled: !viewModel.enablePlaceOrder,
//           loading: viewModel.placeOrderLoading,
//           borderRadius: BorderRadius.circular(5),
//           color: const Color(0xFF022147),
//           borderColor: const Color(0xFF022147),
//           onPressed: viewModel.isBusy
//               ? null
//               : () {
//                   viewModel.onBitPayClick();
//                 },
//         );
//       }
//     }
//
//     return Button(
//       "Place Order",
//       valueKey: const Key("btnPlaceOrder"),
//       width: double.infinity,
//       color: AppColor.secondary,
//       borderColor: AppColor.secondary,
//       loading: viewModel.placeOrderLoading,
//       onPressed: viewModel.isBusy
//           ? null
//           : () {
//               viewModel.submitPlaceOrder();
//             },
//     );
//   }
// }
