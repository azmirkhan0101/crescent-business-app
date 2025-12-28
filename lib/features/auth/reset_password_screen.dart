import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/auth/reset_password_controller.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/password_requirement_widget.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../routes/app_pages.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';


class ResetPasswordScreen extends StatelessWidget {

  final ResetPasswordController controller = ResetPasswordController();
  String resetPasswordToken = Get.arguments;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            const CustomAuthAppbar(),
            SizedBox(height: 30.h),

            /// heading Text
            HeadingTextWidget(
              title: AppText.resetPasswordTitle,
              subTitle: AppText.resetPasswordSubtitle,
            ),
            SizedBox(height: 30.h),

            /// Form fields
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Password Field

                  CustomTextField(
                    onChanged: (String value){
                      controller.checkRequirements(value);
                    },
                    hintText: "Enter New Password",
                    suffixIconPath: Assets.icons.eye,
                    prefixIconPath: Assets.icons.lock,
                    controller: controller.newPasswordController,
                    isPassword: true,
                  ),


                  SizedBox(height: 12.h),

                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "Confirm New Password",
                    suffixIconPath: Assets.icons.eye,
                    prefixIconPath: Assets.icons.lock,
                    controller: controller.confirmPasswordController,
                    isPassword: true,
                  ),

                  // CustomTextFieldWidget(
                  //   maxLines: 1,
                  //   hintText: AppText.confirmNewPassword,
                  //   prefixIcon: Image.asset(
                  //     AssetsPath.lockIcon,
                  //     width: 20.w,
                  //     height: 20.h,
                  //   ),
                  //   isPassword: true,
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            ///required text
            Obx((){
              return PasswordRequirements(
                isEightCharacters: controller.isEightCharacters.value,
                isBothCasesPresent: controller.isBothCasesPresent.value,
                isNumeralPresent: controller.isNumeralPresent.value,
                isSpecialCharPresent: controller.isSpecialCharPresent.value,
              );
            })
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: AppSizes.paddingLarge,
          right: AppSizes.paddingLarge,
          bottom: 50.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child:
            Obx((){
              return CustomButton(
                isLoading: controller.isResetLoading.value,
                text: AppText.resetPasswordButton,
                onPressed: () {
                  controller.resetPasswordToken = resetPasswordToken;
                  controller.resetPassword();
                },
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.buttonTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              );
            }),),
            // CustomButton(
            //   buttonTextStyle: GoogleFonts.familjenGrotesk(
            //       color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
            //   text: AppText.resetPasswordButton,
            //   onPressed: () {
            //     controller.resetPasswordToken = resetPasswordToken;
            //     controller.resetPassword();
            //   },
            // ),
            SizedBox(height: AppSizes.paddingMedium),
            RichTextWidget(
              firstText: AppText.changedYourMind,
              lastText: "  ${AppText.login}",
              onTap: () {
               Get.toNamed(AppRoutes.logIn);
              },
            ),
          ],
        ),
      ),
    );
  }
}
