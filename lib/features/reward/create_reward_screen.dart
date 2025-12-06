import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:organization/controller/reward/reward_controller.dart';
import 'package:organization/features/reward/widget/expiry_limit_section.dart';
import 'package:organization/features/reward/widget/redemption_methods_section.dart';
import 'package:organization/features/reward/widget/upload_image_section.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_text_styles.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../on_boarding/widgets/bottom_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/text_field_title_widget.dart';

class CreateRewardScreen extends StatelessWidget {

  final RewardController controller = Get.find<RewardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Create New Reward',
          style: AppTextStyle.headlineLStyle.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: 'Reward Details',
              language: true,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
              fontSize: 18.sp,
            ),
            SizedBox(height: 12.h),
            // reward name
            TextFieldTitleWidget(text: "Reward name"),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: "title",
              controller: controller.titleController,
            ),
            SizedBox(height: 16.h),
            //description
            TextFieldTitleWidget(text: AppText.description),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: "description",
              maxLines: 3,
              controller: controller.descriptionController,
            ),
            ///upload image section
            SizedBox(height: 20.h),
            UploadImageSection(),
            SizedBox(height: 20.h),

            ExpiryLimitSection(
              controller: controller.redemptionLimitController,
              onDateSelected: (date){
                controller.expiryDate = date;
              },
            ),
            SizedBox(height: 20.h),

            /// RedemptionMethodsSection
            Obx((){
              return RedemptionMethodsSection(
                  qrCode: controller.qrCode.value,
                  nfcTap: controller.nfcTap.value,
                  staticCode: controller.staticCode.value,
                  onQRCodeChanged: (isChecked){
                    controller.qrCode.value = isChecked;
                  },
                  onNfcTapChanged: (isChecked){
                    controller.nfcTap.value = isChecked;
                  },
                  onStaticCodeChanged: (isChecked){
                    controller.staticCode.value = isChecked;
                  }
              );
            }),
            SizedBox(
              height: 20.h,
            ),
            BottomButtonWidget(
              onPressed: () {
                controller.createRewardInStore();
              },
              buttonText: "Create",
            ),
          ],
        ),
      ),
    );
  }


}

//CLASS ENDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD