import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/utils/assets_path.dart';

import '../../core/routes/route_path.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/custom_asset_image.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/info_card_widget.dart';

class StackSetupScreen extends StatelessWidget {
  const StackSetupScreen({super.key});

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
                  const SizedBox(height: 12),

                  /// complete text
                  Text(
                    AppText.businessComplete,
                    style: AppTextStyle.headlineLStyle.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      AppText.businessDesc,
                      style: AppTextStyle.mediumStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: const Color(0xFFDBF881),
                          width: 3.w,
                        ),
                        left: BorderSide(
                          color: const Color(0xFFDBF881),
                          width: 3.w,
                        ),
                        right: BorderSide(
                          color: const Color(0xFFDBF881),
                          width: 3.w,
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),

                    /// Scrollable card content
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4), // নিচে shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16.w),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 16.h),

                              /// profile image
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 0.91.w,
                                    color: const Color(0xFFE4E4E4),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.r),
                                  child: Image.asset(
                                    AssetsPath.businessProfileImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              /// profile texts
                              Text(
                                'Sweet Whisk Bakery',
                                style: AppTextStyle.headlineLStyle.copyWith(
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Business Category',
                                style: AppTextStyle.mediumStyle.copyWith(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF848484),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Whipping Up Smiles, One Treat at a Time!',
                                style: AppTextStyle.cardTextStyle.copyWith(
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// card section (row)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: InfoCard(
                                gradientColor1: const Color(0xFFF3EAFE),
                                gradientColor2: const Color(0xFFE9D9FB),
                                gradientColor3: const Color(0xFFD8C2F6),
                                icon: AssetsPath.globeIcon,
                                title: AppText.website,
                                subtitle: "(555) 123-4567",
                                iconBgColor: const Color(0xFFE2D4F9),
                                iconColor: const Color(0xFF9B6DFF),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: InfoCard(
                                iconColor: const Color(0xFF4CAF50),
                                gradientColor1: const Color(0xFFF0FFD9),
                                gradientColor2: const Color(0xFFE6FBCB),
                                gradientColor3: const Color(0xFFD2F7A2),
                                icon: AssetsPath.callIcon,
                                title: AppText.businessPhone,
                                subtitle: AppText.enterWebsite,
                                iconBgColor: const Color(0xFFDBF7B6),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        /// bottom info card
                        InfoCard(
                          height: 120.h,
                          width: double.infinity,
                          gradientColor1: const Color(0xFFFFFFE0),
                          gradientColor2: const Color(0xFFFFF9D9),
                          gradientColor3: const Color(0xFFFFF2B0),
                          icon: AssetsPath.mailIcon,
                          title: AppText.email,
                          subtitle: "contact@sweetwhiskbakery.com",
                          iconBgColor: const Color(0xFFFFF2C2),
                          iconColor: const Color(0xFFFFC107),
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
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
              backgroundColor: AppColors.black,
              textColor: AppColors.white,
              text: AppText.done,
              onPressed: () {
                context.go(RoutesPath.home);
              },
            ),
          ),
        ],
      ),
    );
  }
}
