import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/under_button_widget.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/app_text_styles.dart';
import '../../core/routes/route_path.dart';
import '../profile/widget/location_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';

class StoreLocationScreen extends StatelessWidget {
  const StoreLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            OnBoardingAppbarWidget(
              totalSteps: 6,
              currentStep: 6,
              title: AppText.location,
              suffix: GestureDetector(
                onTap: () {},
                child: Text(AppText.skip, style: AppTextStyle.mediumStyle),
              ),
            ),
            SizedBox(height: 30.h),

            /// heading Text
            HeadingTextWidget(
              title: "Add Your Store Locations",
              subTitle:
                  "Enter one or more store locations with smart search for quick entry.",
            ),
            SizedBox(height: 50.h),

            /// Form fields
            Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Email Field
                  TextFieldTitleWidget(text: "Search Location"),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "Search",
                    prefixImagePath:
                      AssetsPath.searchIcon,

                  ),
                  SizedBox(height: 16.h),
                  Divider(height: 1.w, color: Colors.grey.shade200),
                  SizedBox(height: 16.h),

                  /// location 1
                  LocationWidget(
                    headingText: AppText.location2,
                    fieldText: AppText.store1Address,
                    deleteTap: () {},
                  ),
                  SizedBox(height: 16.h),

                  /// location 2
                  LocationWidget(
                    headingText: AppText.location2,
                    fieldText: AppText.store1Address,
                    deleteTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// continue Button
      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {
          context.push(RoutesPath.setupCompleteOne);
        },
        buttonText: AppText.continueText,
      ),
    );
  }
}
