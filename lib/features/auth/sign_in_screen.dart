import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../core/routes/route_path.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // final SignInController controller = Get.find<SignInController>();
  final formKey = GlobalKey<FormState>();
  bool isChecked = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              const CustomAuthAppbar(),
              SizedBox(height: 30.h),

              HeadingTextWidget(
                title: AppText.welcomeBack,
                subTitle: AppText.missedBusiness,
              ),
              SizedBox(height: 50.h),

              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Email
                    TextFieldTitleWidget(text: AppText.email),
                    SizedBox(height: AppSizes.paddingSmallH),
                    CustomTextField(
                      hintText: "Enter Email",
                      prefixImagePath: AssetsPath.mailIcon,
                      //  onChanged: (val) => controller.email.value = val,
                    ),
                    SizedBox(height: 10.h),

                    /// Password
                    TextFieldTitleWidget(text: AppText.password),
                    SizedBox(height: AppSizes.paddingSmallH),
                    CustomTextField(
                      hintText: "******",
                      prefixImagePath: AssetsPath.lockIcon,
                      suffixImagePath: AssetsPath.eyeIcon,
                      // onChanged: (val) => controller.password.value = val,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),

              /// Remember + Forgot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Expanded(
                   child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false; //
                              });
                            },
                            activeColor: const Color(0xFFD1FF43),
                            checkColor: AppColors.white,
                          ),
                          CustomText(
                            text: AppText.rememberPassword,
                            language: false,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                            fontSize: 14.sp,
                          ),
                        ],
                      ),
                 ),

                  GestureDetector(
                    onTap: () => context.push(RoutesPath.forgotPassword),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: AppText.forgotPassword,
                            language: false,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                            fontSize: 12.sp,
                          ),
                          Container(
                            height: 1.h,
                            color: AppColors.blackTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// Bottom
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.paddingLarge,
            right: AppSizes.paddingLarge,
            bottom: 50.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: "Login",
                onPressed: () {
                  context.push(RoutesPath.home);
                },
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.buttonTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),
              RichTextWidget(
                firstText: AppText.dontHaveAccount,
                lastText: AppText.signup,
                onTap: () {
                  // Navigate to signup
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
