import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import '../../routes/app_pages.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0, // চাইলে shadow remove করতে
        title: Text(
          "Reward",
          style: AppTextStyle.headlineLStyle.copyWith(fontSize: 20.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w), // right spacing
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.mainNav);
              },

              child: Container(
                height: 40.w,
                width: 40.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5F4F6),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 15.w,
                    color: Colors.black, // icon color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAssetsImage(
              assetsPath: AssetsPath.stackCardImage,
              height: 176.h,
              width: 285.w,
            ),
            Text(
              "Manage Your Rewards",
              style: AppTextStyle.headlineLStyle.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              textAlign: TextAlign.center,
              maxLines: 3,
              "Track redemptions, edit existing rewards, or add something new to surprise your customers.",
              style: AppTextStyle.mediumStyle,
            ),
            SizedBox(height: 12.h),
            CustomButton(

              backgroundColor: const Color(0x26C08FFF),
              widget: Row(
                children: [
                  Icon(Icons.add, size: 20, color: AppColors.buttonTextColor),
                  SizedBox(width: 3.w),
                  Text(
                    "Add Reward",
                    style: AppTextStyle.buttonTextStyle.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.tabScreen);
              },
              text: AppText.continueText,
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
