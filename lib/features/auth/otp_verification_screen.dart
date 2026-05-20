import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/pin_field_widget.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_constants.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/app_text.dart';
import '../../../utils/app_text_styles.dart';
import '../../controller/auth/otp_verification_controller.dart';
import '../../core/context_extension.dart';
import '../widgets/custom_button_widget.dart';

class OtpVerificationScreen extends StatelessWidget {

  final OtpVerificationController controller = Get.find<OtpVerificationController>();
  String email = Get.arguments[emailKey];
  bool isSignup = Get.arguments[isSignupKey];

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            const CustomAuthAppbar(),
            SizedBox(height: 30.h),

            /// Heading Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: AppText.otpHeadline, fontSize: isTab ? 16.sp : 20.sp, fontWeight: FontWeight.w800,),
                SizedBox(height: 8.h),
                Center(child: Text(AppText.otpSubtitle, style: AppTextStyle.mediumStyle)),
                Center(
                  child: Text(
                    email,
                    style: AppTextStyle.mediumStyle.copyWith(
                      color: AppColors.blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            /// Pin Field
            PinFieldWidget(
              controller: controller.otpController,
              isTab: isTab,
              length: 6,
              onChanged: (val){
                controller.onOtpChanged(val);
                },
              onCompleted: (val) => debugPrint("Completed: $val"),
            ),
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
            //Reactive Button
            Obx((){
              return CustomButton(
                isLoading: controller.isOtpVerifying.value,
                text: AppText.continueText,
                onPressed: () {
                  controller.email = email;
                  controller.isSignup = isSignup;
                  if( isSignup ){//OTP FOR SIGNUP
                    controller.submitSignupOtp();
                  }else{//OTP FOR FORGOT PASSWORD
                    controller.submitForgotPasswordOtp();
                  }
                },
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.buttonTextColor,
                  fontSize: isTab ? 12.sp : 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              );
            }),
            SizedBox(height: AppSizes.paddingMedium),
            RichTextWidget(
              firstText: "Haven’t receive any code?",
              lastText: "  Resend Code",
              onTap: () {
                controller.email = email;
                controller.isSignup = isSignup;
                if( isSignup ){
                  controller.resendSignupOtp();
                }else{
                  controller.resendForgotPasswordOTP();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
