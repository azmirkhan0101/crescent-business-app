import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/auth/widgets/custom_auth_appbar.dart';
import 'package:organization/features/auth/widgets/rich_text_widget.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/app_text_styles.dart';
import '../../controller/auth/sign_in_controller.dart';
import '../../core/routes/route_path.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Form key
    final formKey = GlobalKey<FormState>();

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

              /// heading Text
              HeadingTextWidget(
                title: AppText.welcomeBack,
                subTitle: AppText.missedBusiness,
              ),
              SizedBox(height: 50.h),

              /// Form fields
              Form(
                key: formKey,
                child: Column(
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
                      hintText: "******",
                      suffixImagePath: AssetsPath.eyeIcon,
                      prefixImagePath: AssetsPath.lockIcon,
                    ),



                  ],
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),

              /// Remember & Forgot Password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (bool? value) {},
                        activeColor: const Color(0xFFD1FF43),
                        checkColor: AppColors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),

                      CustomText(text:AppText.rememberPassword,
                       language: false,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackTextColor,
                        fontSize: 14.sp,

                      ),
                    ],
                  ),


                  GestureDetector(
                    onTap: () {
                      context.push(RoutesPath.forgotPassword);
                    },
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text:AppText.forgotPassword,
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

        ///button and sign up text
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
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                    color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),
                text: "Login",
                onPressed: () {


                   context.push(RoutesPath.home);

                },
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
