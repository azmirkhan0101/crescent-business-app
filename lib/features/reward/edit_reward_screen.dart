import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/features/reward/widget/expiry_limit_section.dart';
import 'package:organization/features/reward/widget/redemption_methods_section.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import '../../routes/app_pages.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../on_boarding/widgets/under_button_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/text_field_title_widget.dart';

class EditRewardScreen extends StatelessWidget {
  const EditRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {},
        buttonText: "Create",
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Get.toNamed(AppRoutes.mainNav);
          },
        ),
        title: Text(
          'Edit Reward',
          style: AppTextStyle.headlineLStyle.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reward Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor,
              ),
            ),
            SizedBox(height: 12.h),

            // reward name
            TextFieldTitleWidget(text: "Reward name"),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: "10% Off Latte",
            ),
            SizedBox(height: 16.h),
            //description
            TextFieldTitleWidget(text: AppText.description),
            CustomTextField(
              hintText: "Get a free coffee on your next visit.",
              maxLines: 3,
            ),
            ///upload image section
            SizedBox(height: 20.h),
            ///upload image section


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomCard(
                  height: 88.h,
                  width: 88.w,
                  child: Image.asset(
                    AssetsPath.rankBadge2Icon,
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton(
                        buttonTextStyle: AppTextStyle.buttonTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),

                        backgroundColor: Color(0x26C08FFF),
                        width: double.infinity,
                        text: "Change Image",
                        onPressed: () {},
                      ),
                      SizedBox(width: 8.h),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "delete image",
                          style: AppTextStyle.mediumStyle.copyWith(
                            color: Color(0xFFF0323C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const ExpiryLimitSection(),
            const SizedBox(height: 25),

            /// RedemptionMethodsSection
            const RedemptionMethodsSection(),
          ],
        ),
      ),
    );
  }
}
