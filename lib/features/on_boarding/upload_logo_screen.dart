import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/controller/auth/sign_up_controller.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/bottom_button_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';

import '../../../utils/app_size.dart';
import '../../routes/app_pages.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/profile_avatar_widget.dart';

class UploadLogoScreen extends StatefulWidget {
  const UploadLogoScreen({super.key});

  @override
  State<UploadLogoScreen> createState() => _UploadLogoScreenState();
}

class _UploadLogoScreenState extends State<UploadLogoScreen> {

  final SignUpController controller = Get.find<SignUpController>();
  bool hasImage = false; // initially no image
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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
                onTap: () {
                  Get.toNamed(AppRoutes.businessContactInfo);
                },
                child:
                CustomText(text: AppText.skip,fontSize: 14.sp,color: AppColors.secondaryTextColor,fontWeight: FontWeight.w400,),

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
                      selectedImage: selectedImage,
                      pickImage: () {
                        _pickImage();
                      },
                    ),
                    SizedBox(height: 10.h),
                    CustomText(text:"Tap to add your business logo.",fontSize: 14.sp,color: AppColors.secondaryTextColor,fontWeight: FontWeight.w400,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// continue Button
      bottomNavigationBar: BottomButtonWidget(
        onPressed: () {
          if( hasImage ){
            controller.businessSignupModel.logo = selectedImage;
            Get.toNamed(AppRoutes.businessContactInfo);
          }else{
            _pickImage();
          }
        },
        buttonText: hasImage ? AppText.continueText : "Add Logo",
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        hasImage = true;
      });
    }
  }
}
