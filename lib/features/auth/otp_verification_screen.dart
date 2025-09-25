import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/pin_field_widget.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/app_text.dart';
import '../../../utils/app_text_styles.dart';
import '../../core/routes/route_path.dart';
import '../../core/show_snackbar.dart';
import '../widgets/custom_button_widget.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<OtpVerificationController>();
    final TextEditingController pinController = TextEditingController();
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
              controller: pinController,
              //  controller: controller.pinController,
              length: 5,
              // onChanged: controller.onPinChanged,
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
            /// Reactive Button
            CustomButton(
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              text: AppText.continueText,
              onPressed: () {
                context.push(RoutesPath.resetPassword);
              },
            ),

            SizedBox(height: AppSizes.paddingMedium),
            RichTextWidget(
              firstText: AppText.dontHaveAccount,
              lastText: AppText.signup,
              onTap: () {
                CustomSnackBar.show(
                  context,
                  message: "sign up screen",
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
