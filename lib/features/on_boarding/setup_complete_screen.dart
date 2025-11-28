import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/auth/setup_complete_controller.dart';
import 'package:organization/features/on_boarding/widgets/animated_setup_background.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/info_card_widget.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:organization/utils/assets_path.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text.dart';

class BusinessSetupCompleteScreen extends StatelessWidget {

  final storage = GetStorage();
  final SetupCompleteController controller = Get.find<SetupCompleteController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Obx((){
        if( controller.model.value == null ){
          return Center( child: Text("No data found"),);
        }else{
          return body();
        }
      }),
    );
  }

  body(){
    return Stack(
      children: [
        AnimatedGradientBackground(),
        Column(
          children: [
            SizedBox(height: 60.h),
            Align(
              alignment: AlignmentGeometry.topRight,
              child: IconButton(onPressed: (){
                Get.toNamed(AppRoutes.mainNav);
              }, icon: Icon(Icons.close)),
            ),
            /// complete icon
            CustomAssetsImage(
              assetsPath: AssetsPath.completeIcon,
              height: 80.h,
              width: 80.w,
            ),
            SizedBox(height: 12),
            /// complete text
            CustomText(text:AppText.businessComplete,
              fontWeight: FontWeight.w700,
              language: true,
              fontSize: 20.sp,
              color: AppColors.headlineTColor,
            ),
            Text(
              AppText.businessDesc,
              style: AppTextStyle.mediumStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox( height: 20.h,),
            // Main content scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFE2E2E2),
                            width: 3.w,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all( 8.h ),

                        /// Scrollable card content
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 12.h,),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x19000000),
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
                                      child: Image.network(
                                        controller.model.value!.logoPath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) {
                                          return Icon(Icons.person, size: 40.r,);
                                        },
                                      )

                                    ),
                                  ),
                                  /// profile texts
                                  Text(
                                    controller.model.value!.name,
                                    style: AppTextStyle.headlineLStyle.copyWith(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    controller.model.value!.category,
                                    style: AppTextStyle.mediumStyle.copyWith(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF848484),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    controller.model.value!.tagline,
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
                                    subtitle: controller.model.value!.businessPhoneNumber,
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
                              subtitle: controller.model.value!.businessEmail,
                              iconBgColor: const Color(0xFFFFF2C2),
                              iconColor: const Color(0xFFFFC107),
                            ),
                            SizedBox( height: 10.h,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h,),
            Center(
              child: CustomButton(

                backgroundColor: AppColors.black,
                textColor: AppColors.black,
                text: AppText.done,

                buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                onPressed: () {
                  String accessToken = storage.read( accessTokenKey );
                  print("Access tokennnnnnnnnnnnnnn: ${accessToken}");
                },
              ),
            ),
            SizedBox(height: 35.h,)
          ],
        ),
      ],
    );
  }
}
