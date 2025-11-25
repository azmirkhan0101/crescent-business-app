import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/pin_field_widget.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/app_text.dart';
import '../../../utils/app_text_styles.dart';
import '../../controller/auth/otp_verification_controller.dart';
import '../../core/show_snackbar.dart';
import '../../routes/app_pages.dart';
import '../widgets/custom_button_widget.dart';

class OtpVerificationScreen extends StatelessWidget {

  final OtpVerificationController controller = Get.find<OtpVerificationController>();


  @override
  Widget build(BuildContext context) {

    final TextEditingController pinController = TextEditingController();
    String email = Get.arguments;

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
                Text(AppText.otpHeadline, style: AppTextStyle.headlineLStyle),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(AppText.otpSubtitle, style: AppTextStyle.mediumStyle),
                    SizedBox(width: 3.w),
                    Text(
                      AppText.emailText,
                      style: AppTextStyle.mediumStyle.copyWith(
                        color: AppColors.blackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 50.h),

            /// Pin Field
            PinFieldWidget(
              controller: controller.otpController,
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
            CustomButton(
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              text: AppText.continueText,
              onPressed: () {
                //TODO: VERIFY CODE AND SHOW SNACK OR GO TO RESET PASSWORD SCREEN
                controller.email = email;
                controller.submitOtp();
                //Get.toNamed(AppRoutes.resetPassword);
              },
            ),

            SizedBox(height: AppSizes.paddingMedium),
            RichTextWidget(
              firstText: "Haven’t receive any code?",
              lastText: "Resend Code",
              onTap: () {
                //TODO: SHOW THIS SNACKBAR AFTER CODE SENT FROM CONTROLLER
                CustomSnackBar.show(
                  context,
                  message: "A verification code has been sent to your email,",
                  icon: Icons.check_circle,
                  backgroundColor: Colors.green,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
