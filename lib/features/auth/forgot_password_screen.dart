import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/toast_message.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/app_text.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';
import '../../utils/assets_path.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              const CustomAuthAppbar(),
              SizedBox(height: 30.h),

            //heading text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: AppText.forgotPasswordTitle,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  color: AppColors.headlineTColor,
                  language: true,
                ),

                SizedBox(height: AppSizes.paddingSmallH),
                CustomText(
                  text: AppText.forgotPasswordSubtitle,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.secondaryTextColor,
                  language: false,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),

              SizedBox(height: 50.h),
              Form(
                //  key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldTitleWidget(text: AppText.email),
                    SizedBox(height: AppSizes.paddingSmallH),
                    CustomTextField(
                      hintText: AppText.emailText,
                      prefixImagePath: AssetsPath.mailIcon,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.paddingLarge,
            right: AppSizes.paddingLarge,
            bottom: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.buttonTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                text: AppText.continueText,
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  Get.toNamed(AppRoutes.mainNav);
                },
              ),
              SizedBox(height: AppSizes.paddingMedium),
              RichTextWidget(
                firstText: AppText.dontHaveAccount,
                lastText: AppText.signup,
                onTap: () {
                  Toast.successToast("Sign up screen");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
