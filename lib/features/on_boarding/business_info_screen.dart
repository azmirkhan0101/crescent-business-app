import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/under_button_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';
import '../../../utils/app_size.dart';
import '../../core/routes/route_path.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            OnBoardingAppbarWidget(
              totalSteps: 6,
              currentStep: 2,
              title: AppText.details,
            ),

            SizedBox(height: 30.h),

            /// heading Text
            HeadingTextWidget(
              title: AppText.businessInfoTitle,
              subTitle: AppText.businessInfoSubtitle,
            ),
            SizedBox(height: 50.h),

            /// Form fields
            Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //name
                  TextFieldTitleWidget(text: AppText.name),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(hintText: AppText.enterName),
                  SizedBox(height: 16.h),
                  // tagline
                  TextFieldTitleWidget(text: AppText.tagline),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(hintText: AppText.enterTagline),
                  SizedBox(height: 16.h),
                  //description
                  TextFieldTitleWidget(text: AppText.enterDescription),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(hintText: AppText.description, maxLines: 4),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {
          context.push(RoutesPath.accountCreation);
        },
        buttonText: AppText.continueText,
      ),
    );
  }
}
