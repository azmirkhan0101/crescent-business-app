import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/under_button_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_size.dart';
import '../../core/routes/route_path.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_avatar_widget.dart';

class UploadLogoScreen extends StatefulWidget {
  const UploadLogoScreen({super.key});

  @override
  State<UploadLogoScreen> createState() => _UploadLogoScreenState();
}

class _UploadLogoScreenState extends State<UploadLogoScreen> {
  bool _hasImage = false; // initially no image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            /// Top AppBar
            OnBoardingAppbarWidget(
              totalSteps: 6,
              currentStep: 4,
              title: AppText.branding,
              suffix: GestureDetector(
                onTap: () {},
                child: Text(
                  AppText.skip,
                  style: AppTextStyle.mediumStyle,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            /// Heading Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
              child: HeadingTextWidget(
                title: AppText.uploadLogoTitle,
                subTitle: AppText.uploadLogoSubtitle,
              ),
            ),

            /// Profile section center of screen
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileAvatar(
                      assetImage: AssetsPath.addProfileIcon,
                      onTap: () {
                        setState(() {
                          _hasImage = true; // image selected
                        });
                      },
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Tap to add your business logo.",
                      style: AppTextStyle.mediumStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// continue Button
      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {
          context.push(RoutesPath.businessContactInfo);
        },
        buttonText: _hasImage ?AppText.continueText : "Add Logo",
      ),
    );
  }
}
