import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/utils/assets_path.dart';
import '../../core/routes/route_path.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/custom_button_widget.dart';

class OnBoardingStoreScreen extends StatelessWidget {
  const OnBoardingStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen gradient background
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),

          // Main content scrollable
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),

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
                   SizedBox(height: 8.h),

                  /// complete text
                  Text(
                    "Rewards Redeem Successfully",
                    style: AppTextStyle.headlineLStyle.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),

                  Text(
                    "Customer reward redeemed successfully.",
                    style: AppTextStyle.mediumStyle,
                    textAlign: TextAlign.center,
                  ),

                 SizedBox(height: 24.h,),


              Container(
                height: 152.h,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// -------- Title
                    Row(
                      children: [
                        Image.asset(
                          AssetsPath.rankBadge1Icon, // ✅ fixed
                          height: 24.h,
                          width: 24.w,
                        ),

                        SizedBox(width: 8.w),
                        Text(
                          "Free Coffee",
                          style: AppTextStyle.cardTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 8.h),

                    /// -------- --------
                    Row(

                      children: [
                        Text(
                          'Redeemed On: ',
                          style: AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp),
                        ),
                        Text(
                          '2/7/2025 - 12:20:30',
                          style: AppTextStyle.mediumStyle.copyWith(fontWeight: FontWeight.w500,color: AppColors.blackTextColor),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    /// -------- Redemptions + QR --------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "120",
                              style: AppTextStyle.headlineLStyle.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'redemptions',
                              style: AppTextStyle.mediumStyle.copyWith(
                                fontSize: 12.sp,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Redeem via",
                              style: AppTextStyle.mediumStyle.copyWith(
                                fontSize: 12.sp,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                            CustomAssetsImage(
                              assetsPath: AssetsPath.qrCodeIcon,
                              height: 24.h,
                              width: 24.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),


























                ],
              ),
            ),
          ),

          // Bottom button
          Positioned(
            bottom: 50.h,
            left: 16.w,
            right: 16.w,
            child: CustomButton(
              backgroundColor: AppColors.black,
              textColor: AppColors.white,
              text: AppText.done,
              onPressed: () {
                context.go(RoutesPath.home);
              },         buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
