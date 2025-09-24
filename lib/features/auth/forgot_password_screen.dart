import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/auth/forgot_pass_controller.dart';
import '../../core/routes/route_path.dart';
import '../../core/show_snackbar.dart';
import '../../core/toast_message.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/app_text.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';
import '../widgets/custom_asset_image.dart';
import '../../utils/assets_path.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Existing controller use korchi
    final controller = Get.find<ForgotPasswordController>();

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
              HeadingTextWidget(
                title: AppText.forgotPasswordTitle,
                subTitle: AppText.forgotPasswordSubtitle,
              ),
              SizedBox(height: 50.h),
              Form(
                key: controller.formKey,
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

                    // CustomTextFieldWidget(
                    //   controller: controller.emailController,
                    //   textStyle: AppTextStyle.cardTextStyle.copyWith(fontSize: 14.sp),
                    //   hintText: "talha@gmail.com",
                    //   prefixIcon: CustomAssetsImage(
                    //     width: 20.w,
                    //     height: 20.h,
                    //     assetsPath: AssetsPath.mailIcon,
                    //   ),
                    //   onChanged: controller.onEmailChanged,
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return "Email cannot be empty";
                    //     }
                    //     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    //       return "Enter a valid email";
                    //     }
                    //     return null;
                    //   },
                    // ),
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
                    color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
                text: AppText.continueText,
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  context.push(RoutesPath.otpVerify);
                  // if (controller.formKey.currentState?.validate() ?? false) {
                  //   controller.submit((email) {
                  //     context.push(RoutesPath.otpVerify);
                  //   });
                  // } else {
                  //   Toast.errorToast("Please enter a valid email");
                  // }
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
