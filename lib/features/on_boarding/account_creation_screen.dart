import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/under_button_widget.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';

class AccountCreationScreen extends StatelessWidget {
  const AccountCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            OnBoardingAppbarWidget(
              totalSteps: 6,
              currentStep: 3,
              title: AppText.account,
            ),
            SizedBox(height: 30.h),

            /// heading Text
            HeadingTextWidget(
              title: AppText.accountTitle,
              subTitle: AppText.accountSubTitle,
            ),
            SizedBox(height: 50.h),

            /// Form fields
            Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Email Field
                  TextFieldTitleWidget(text: AppText.email),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "Enter Email",
                    prefixImagePath: AssetsPath.mailIcon,
                  ),
                  SizedBox(height: 10.h),

                  /// Password Field
                  TextFieldTitleWidget(text: AppText.password),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "**********",
                    suffixImagePath: AssetsPath.eyeIcon,
                    prefixImagePath: AssetsPath.lockIcon,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 4.h,
                    color: Color(0xFFD1FF43),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                  ),
                );
              }),
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAssetsImage(assetsPath: AssetsPath.infoIcon),
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.justify,
                    text: AppText.passwordRequirements,
                    language: false,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    overflow: TextOverflow.visible,
                  ),

                ),
              ],
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),

      /// continue Button
      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {
          Get.toNamed(AppRoutes.uploadLogo);
        },
        buttonText: AppText.continueText,
      ),
    );
  }
}
