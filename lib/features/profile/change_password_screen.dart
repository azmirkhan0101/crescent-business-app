import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/profile/profile_settings_controller.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/widgets/text_field_title_widget.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/assets_path.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../utils/app_text.dart';
import '../../utils/assets_gen/assets.gen.dart';
import '../auth/widgets/password_requirement_widget.dart';
import '../widgets/custom_asset_image.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';

class ChangePasswordScreen extends StatelessWidget {

  final ProfileSettingsController controller = Get.find<ProfileSettingsController>();

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
              title: "Change Password",
              subTitle:"Secure your account by changing your password",
            ),
            SizedBox(height: 30.h),

            /// Form fields
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Password Field

                  /// Password
                  TextFieldTitleWidget(text: "Current Password"),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "**********",
                    controller: controller.currentPassword,
                    prefixIconPath: Assets.icons.lock,
                    suffixIconPath: Assets.icons.eye,
                    isPassword: true,
                    // onChanged: (val) => controller.password.value = val,
                  ),

                  SizedBox(height: 12.h),


                  /// Password
                  TextFieldTitleWidget(text: "New Password"),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "**********",
                    controller: controller.newPassword,
                    onChanged: (String value){
                      controller.checkRequirements(value);
                    },
                    prefixIconPath: Assets.icons.lock,
                    suffixIconPath: Assets.icons.eye,
                    isPassword: true,
                    // onChanged: (val) => controller.password.value = val,
                  ),
                  SizedBox(height: 16.h),
                  ///container color
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // gap
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 26.h),
                  /// Password
                  TextFieldTitleWidget(text: "Confirm New Password"),
                  SizedBox(height: AppSizes.paddingSmallH),




              CustomTextField(
                    hintText: "**********",
                    controller: controller.confirmPassword,
                    prefixIconPath: Assets.icons.lock,
                    suffixIconPath: Assets.icons.eye,
                    isPassword: true,
                    // onChanged: (val) => controller.password.value = val,
                  ),
                ],
              ),
            ),
            SizedBox( height: 10.h,),
            ///required text
            Obx((){
              return PasswordRequirements(
                isEightCharacters: controller.isEightCharacters.value,
                isBothCasesPresent: controller.isBothCasesPresent.value,
                isNumeralPresent: controller.isNumeralPresent.value,
                isSpecialCharPresent: controller.isSpecialCharPresent.value,
              );
            }),
            SizedBox(height: 42.h),
            Center(
              child: CustomButton(
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                    color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
                text: "Save",
                onPressed: () {
                  controller.changePassword();
                },
              ),
            ),
            SizedBox( height: 40.h,)
          ],
        ),
      ),
    );
  }
}

