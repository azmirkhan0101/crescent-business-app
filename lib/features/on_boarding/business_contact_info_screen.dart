import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/auth/sign_up_controller.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/bottom_button_widget.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_size.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';

class BusinessContactInfoScreen extends StatelessWidget {

  final SignUpController controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            OnBoardingAppbarWidget(
              suffix:GestureDetector(
                onTap: (){
                  controller.businessModel.businessPhoneNumber = "";
                  controller.businessModel.businessEmail = "";
                  controller.businessModel.businessWebsite = "";
                  Get.toNamed(AppRoutes.storeLocation);
                },
                  child: CustomText(text: AppText.skip,fontSize: 14.sp,color: AppColors.secondaryTextColor,fontWeight: FontWeight.w400,)),
              totalSteps: 6,
              currentStep: 5,
              title: "Contact",
            ),
            SizedBox(height: 30.h),

            /// heading Text
            HeadingTextWidget(
              title: AppText.contactInfoTitle,
              subTitle: AppText.contactInfoSubtitle,
            ),
            SizedBox(height: 50.h),

            /// Form fields
            Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //name
                  TextFieldTitleWidget(text: AppText.businessPhoneNumber),
                  SizedBox(height: AppSizes.paddingSmallH),

                  CustomTextField(
                    hintText: AppText.enterBusinessPhoneNumber,
                    prefixImagePath: AssetsPath.callIcon,
                    controller: controller.businessPhoneController,
                  ),

                  //       ),
                  TextFieldTitleWidget(text: AppText.businessEmail),

                  CustomTextField(
                    hintText: AppText.enterBusinessEmail,
                    prefixImagePath: AssetsPath.mailIcon,
                    controller: controller.businessEmailController,
                  ),

                  TextFieldTitleWidget(text: AppText.website),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: AppText.enterWebsite,
                    prefixImagePath: AssetsPath.globeIcon,
                    controller: controller.businessWebsiteController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// continue Button
      bottomNavigationBar: BottomButtonWidget(
        onPressed: () {
          controller.validateBusinessContactInfo();
        },
        buttonText: AppText.continueText,
      ),
    );
  }
}
