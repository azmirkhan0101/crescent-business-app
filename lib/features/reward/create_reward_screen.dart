import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/features/reward/widget/expiry_limit_section.dart';
import 'package:organization/features/reward/widget/redemption_methods_section.dart';
import 'package:organization/features/reward/widget/upload_image_section.dart';
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

      bottomNavigationBar: UnderButtonWidget(onPressed: () {


      }, buttonText: "Create"),


      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,size: 20,),
          onPressed: () {
            context.pop();

          },
        ),
        title:  Text(
          'Create New Reward',
          style:AppTextStyle.headlineLStyle.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Reward Details', style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor
            ),
            ),
            SizedBox(height: 12.h,),
            // tagline
            TextFieldTitleWidget(text: AppText.tagline),
            SizedBox(height: 8.h,),
            // CustomTextFieldWidget(
            //   hintText: AppText.enterTagline,
            // ),
            SizedBox(height: 12.h,),
            //description
            TextFieldTitleWidget(text: AppText.description),
            SizedBox(height: 8.h,),
            // Description field (height 120, maxLines 4)
            // CustomTextFieldWidget(
            //   hintText: AppText.description,
            //   maxLines: 4,
            // ),
            ///upload image section
            const SizedBox(height: 25),
            const UploadImageSection(),
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