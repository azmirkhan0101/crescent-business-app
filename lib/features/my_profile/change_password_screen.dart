import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/password_requirement_widget.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';
import 'package:organization/features/widgets/text_field_title_widget.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';


class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
                    prefixImagePath: AssetsPath.lockIcon,
                    suffixImagePath: AssetsPath.eyeIcon,
                    // onChanged: (val) => controller.password.value = val,
                  ),

                  SizedBox(height: 12.h),


                  /// Password
                  TextFieldTitleWidget(text: "New Password"),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "**********",
                    prefixImagePath: AssetsPath.lockIcon,
                    suffixImagePath: AssetsPath.eyeIcon,
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
                    prefixImagePath: AssetsPath.lockIcon,
                    suffixImagePath: AssetsPath.eyeIcon,
                    // onChanged: (val) => controller.password.value = val,
                  ),
                ],
              ),
            ),
            SizedBox(height: 42.h),
            Center(
              child: CustomButton(
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                    color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
                text: "Save",
                onPressed: () {
                  Get.toNamed(AppRoutes.categorySelection);
                },
              ),
            ),


          ],
        ),
      ),


    );
  }
}
