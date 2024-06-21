import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NFCScannerBottomSheet extends StatefulWidget {
  final Function() onPressed;
  const NFCScannerBottomSheet({super.key, required this.onPressed});

  @override
  State<NFCScannerBottomSheet> createState() => _NFCScannerBottomSheetState();
}

class _NFCScannerBottomSheetState extends State<NFCScannerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Scan Card",style: AppTextStyle.titleLarge),
          ),
          Text("Hold your Card to the back \n of your phone.",textAlign: TextAlign.center,style: AppTextStyle.titleSmall.copyWith(fontWeight: FontWeight.w400,fontSize: 12)),
          Lottie.asset("assets/animations/nfc.json"),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Button(
                'Cancel',
                valueKey: const Key("btnCancelScan"),
                width: double.infinity,
                color: AppColor.primary,
                borderColor: AppColor.primary,
                onPressed: widget.onPressed),
          ),
        ],
      )),
    );
  }
}
