import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';

import '../../../controller/redeem/redeem_controller.dart';
import '../../widgets/custom_card_widget.dart';
import 'apply_widget.dart';

class StaticCodeWidget extends StatelessWidget {
   StaticCodeWidget({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final RedeemController controller = Get.find<RedeemController>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "Enter Redeem Code",
          style: AppTextStyle.headlineLStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 150.h),
        SizedBox(
          height: 70.h,
          width: 279.w,
          child: CustomCard(
            child: Center(
              child: TextField(
                controller: textEditingController,
                textAlign: TextAlign.center,
                style: AppTextStyle.mediumStyle.copyWith(
                  color: AppColors.buttonTextColor,
                ),
                decoration: InputDecoration(
                  hintText: "enter your code here",
                  hintStyle: AppTextStyle.mediumStyle.copyWith(
                    color: AppColors.buttonTextColor.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
        Obx((){
          if( controller.isStaticCodeInvalid.value ){
            return Padding(padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text("Invalid code. Please try again.", style: TextStyle(color: AppColors.blackishRed, fontWeight: FontWeight.w400),),
            );
          }else{
            return SizedBox.shrink();
          }
        }),
        SizedBox(height: 15.h),
        ApplyWidget(
          onPressed: () {
            controller.redeemReward(code: textEditingController.text.trim(), method: "static-code");
          },
        ),
      ],
    );
  }
}