import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/core/routes/route_path.dart';
import 'package:organization/features/reward/widget/expiry_limit_section.dart';
import 'package:organization/features/reward/widget/redemption_methods_section.dart';
import 'package:organization/features/reward/widget/upload_image_section.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_text_styles.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../on_boarding/widgets/under_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/text_field_title_widget.dart';

class CreateRewardScreen extends StatelessWidget {
  const CreateRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {
          context.push(RoutesPath.editReward);

        },
        buttonText: "Create",
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Create New Reward',
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
            CustomText(text: 'Reward Details',
            language: true,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
              fontSize: 18.sp,
            ),

            // Text(
            //   'Reward Details',
            //   style: TextStyle(
            //     fontSize: 16.sp,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.blackTextColor,
            //   ),
            // ),
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
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: "Get a free coffee on your next visit.",
              maxLines: 3,
            ),
            ///upload image section
             SizedBox(height: 20.h),
            const UploadImageSection(),
            SizedBox(height: 20.h),

            const ExpiryLimitSection(),
            SizedBox(height: 20.h),

            /// RedemptionMethodsSection
            const RedemptionMethodsSection(),
          ],
        ),
      ),
    );
  }
}
