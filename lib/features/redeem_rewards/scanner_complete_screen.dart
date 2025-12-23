import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/redeem_rewards/widgets/redeem_complete_card_widget.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/utils/assets_path.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/custom_button_widget.dart';

class RedeemScannerCompleteScreen extends StatelessWidget {
  const RedeemScannerCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: Container(
        color: Color(0xFFD1FF43),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric( horizontal: 16.w, vertical: 25.h),
            child: CustomButton(
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700),
              backgroundColor: AppColors.black,
              textColor: AppColors.white,
              text: AppText.done,
              onPressed: () => Get.toNamed(AppRoutes.mainNav),
            ),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),

              /// Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Color(0x0DD1FF43),
                    ),
                    child: CustomAssetsImage(
                      assetsPath: AssetsPath.crossIcon,
                    ),
                  ),
                ],
              ),

              /// complete icon
              CustomAssetsImage(
                assetsPath: AssetsPath.complete1Icon,
                height: 80.h,
                width: 80.w,
              ),
               SizedBox(height: 12.h),

              /// complete text
              Text(
                "Rewards Redeem Successfully",
                style: AppTextStyle.headlineLStyle.copyWith(
                  fontSize: 20.sp,
                ),
              ),
               SizedBox(height: 8.h),
              Text(
                "Customer reward redeemed successfully.",
                style: AppTextStyle.mediumStyle
              ),

              const SizedBox(height: 24),

              RedeemCompleteCardWidget(),


            ],
          ),
        ),
      ),
    );
  }
}
