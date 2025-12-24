import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import '../../../controller/redeem/redeem_controller.dart';
import '../../../routes/app_pages.dart';
import '../../widgets/custom_card_widget.dart';
import 'apply_widget.dart';

class StaticCodeWidget extends StatelessWidget {
   StaticCodeWidget({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final RedeemController controller = Get.find<RedeemController>();

    return Column(
      mainAxisSize: MainAxisSize.min, // Changed to min so it doesn't try to take full screen height
      children: [
        Text(
          "Enter Redeem Code",
          style: AppTextStyle.headlineLStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 70.h),
        SizedBox(
          height: 70.h,
          width: 279.w,
          child: CustomCard(
            // ✅ Removed Expanded. TextField now sits directly inside Center/CustomCard.
            child: Center(
              child: TextField(
                controller: textEditingController,
                textAlign: TextAlign.center,
                style: AppTextStyle.mediumStyle.copyWith(
                  color: AppColors.buttonTextColor,
                ),
                decoration: InputDecoration(
                  hintText: "enter your code here", // Fixed typo "you" to "your"
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
        SizedBox(height: 20.h),
        ApplyWidget(
          onPressed: () {
            controller.redeemReward(code: textEditingController.text.trim(), method: "static-code");
            textEditingController.clear();
          },
        ),
      ],
    );
  }
}