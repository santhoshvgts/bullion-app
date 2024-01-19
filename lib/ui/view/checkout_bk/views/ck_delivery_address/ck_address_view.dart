// import 'package:bullion/core/res/colors.dart';
// import 'package:bullion/core/res/images.dart';
// import 'package:bullion/core/res/styles.dart';
// import 'package:bullion/ui/view/checkout_bk/checkout_view_model.dart';
// import 'package:bullion/ui/view/checkout_bk/views/ck_address_view_model.dart';
// import 'package:bullion/ui/view/vgts_builder_widget.dart';
// import 'package:bullion/ui/widgets/shimmer_effect.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class CkAddressView extends VGTSBuilderWidget<CkAddressViewModel> {
//   const CkAddressView({Key? key}) : super(key: key);

//   @override
//   Widget viewBuilder(BuildContext context, AppLocalizations locale, CkAddressViewModel viewModel, Widget? child) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Shipping Addresses')),
//       body: viewModel.isBusy
//           ? buildBusyState()
//           : viewModel.userAddressList.isEmpty
//               ? buildEmptyState()
//               : buildAddressList(viewModel),
//     );
//   }

//   @override
//   CkAddressViewModel viewModelBuilder(BuildContext context) {
//     return CkAddressViewModel();
//   }

//   Widget buildBusyState() {
//     return Column(
//       children: [1, 2, 3, 4]
//           .map((e) =>  Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: ShimmerEffect(
//                   height: 100,
//                   width: double.infinity,
//                 ),
//               ))
//           .toList(),
//     );
//   }

//   Widget buildEmptyState() {
//     return Container(
//       color: Colors.white,
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(Images.iconEmptyAddress, width: 150, height: 150, fit: BoxFit.contain),
//           const SizedBox(height: 10),
//           const Text("Add New Address", textAlign: TextAlign.center, style: AppTextStyle.titleMedium),
//           const SizedBox(height: 15),
//           const Text("", textAlign: TextAlign.center, style: AppTextStyle.bodyMedium),
//         ],
//       ),
//     );
//   }

//   Widget buildAddressList(CheckoutPageViewModel viewModel) {
//     return ListView.separated(
//       itemCount: viewModel.userAddressList.length + 1,
//       separatorBuilder: (context, index) => const SizedBox(height: 10),
//       itemBuilder: (context, index) {
//         if (index == viewModel.userAddressList.length) {
//           return buildAddAddressButton(viewModel);
//         }
//         var userAddress = viewModel.userAddressList[index];
//         return AddressCardItem(
//           userAddress,
//           selected: viewModel.selectedAddressId == userAddress.id,
//           onPressed: () => viewModel.onAddressSelect(userAddress),
//           onEditClick: () => viewModel.onAddEditShippingAddress(addressId: userAddress.id),
//         );
//       },
//     );
//   }

//   Widget buildAddAddressButton(CheckoutPageViewModel viewModel) {
//     return InkWell(
//       onTap: () => viewModel.onAddEditShippingAddress(),
//       child: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const Icon(Icons.add, color: AppColor.primary, size: 25),
//             const SizedBox(width: 5),
//             Text(
//               "Add Shipping Address",
//               style: AppTextStyle.titleMedium.copyWith(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
